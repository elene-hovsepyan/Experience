# Install and load required packages
required_packages <- c("dplyr")
for (pkg in required_packages) {
  if (!require(pkg, character.only = TRUE)) {
    install.packages(pkg, repos = "http://cran.us.r-project.org")
    library(pkg, character.only = TRUE)
  }
}

# Read data using file.choose()
file_path <- file.choose()
data <- read.csv(file_path, dec = ",", row.names = NULL, check.names = FALSE)

# Print column names for verification
cat("Column names in dataset:\n")
print(colnames(data))

# Select and rename relevant columns using exact column names
data <- data %>%
  select(
    "I regularly recycle items like paper, plastic, and glass.",
    "I believe environmental problems are a major issue in Armenia.",
    "I feel that individual actions can make a real impact on the environment.",
    "Would you recycle if there were more recycling bins in Armenia?"
  ) %>%
  rename(
    RegularlyRecycle = "I regularly recycle items like paper, plastic, and glass.",
    EnvironmentalProblemsMajor = "I believe environmental problems are a major issue in Armenia.",
    IndividualActionsImpact = "I feel that individual actions can make a real impact on the environment.",
    MoreBinsRecycle = "Would you recycle if there were more recycling bins in Armenia?"
  )

# Convert ordinal variables to numeric
ordinal_vars <- c("RegularlyRecycle", "EnvironmentalProblemsMajor", "IndividualActionsImpact")
data[ordinal_vars] <- lapply(data[ordinal_vars], as.numeric)

# Convert categorical variable to factor
data$MoreBinsRecycle <- factor(data$MoreBinsRecycle, levels = c("Yes", "Maybe", "No"))

# Data validation
if (nrow(data) == 0) stop("Error: Data frame is empty.")
required_cols <- c("RegularlyRecycle", "EnvironmentalProblemsMajor", "MoreBinsRecycle", "IndividualActionsImpact")
missing_cols <- setdiff(required_cols, colnames(data))
if (length(missing_cols) > 0) stop(paste("Error: Missing columns:", paste(missing_cols, collapse = ", ")))

# ==============================
# Proportion Tests (Z-test Approach)
# ==============================

# Function for proportion test using Z-test
prop_test_z <- function(successes, n, p0, test_name) {
  cat("\n", test_name, "\n")
  p_hat <- successes / n
  z <- (p_hat - p0) / sqrt(p0 * (1 - p0) / n)
  p_value <- pnorm(z) # One-sided (less than)
  cat("Sample size:", n, "\n")
  cat("Observed proportion:", round(p_hat, 4), "\n")
  cat("Hypothesized proportion:", p0, "\n")
  cat("Z-statistic:", round(z, 4), "\n")
  cat("P-value:", round(p_value, 4), "\n")
  cat("Conclusion:", ifelse(p_value < 0.05, 
                            paste("Reject H0: Proportion is less than", p0), 
                            paste("Fail to reject H0: Proportion is at least", p0)), "\n")
}

# Proportion Test 1: Regular Recycling (≥32% score 4 or 5, international benchmark)
regular_recyclers <- sum(data$RegularlyRecycle >= 4, na.rm = TRUE)
n_regular <- sum(!is.na(data$RegularlyRecycle))
prop_test_z(regular_recyclers, n_regular, 0.32, "Proportion Test: Regular Recycling (≥32% score 4 or 5)")

# Proportion Test 2: Willingness to Recycle with More Bins (≥80% say Yes, international benchmark)
yes_recycle <- sum(data$MoreBinsRecycle == "Yes", na.rm = TRUE)
n_recycle <- sum(!is.na(data$MoreBinsRecycle))
prop_test_z(yes_recycle, n_recycle, 0.80, "Proportion Test: Willingness to Recycle with More Bins (≥80% Yes)")

# Proportion Test 3: Environmental Problems Major (≥80% score 4 or 5, international benchmark)
env_concern <- sum(data$EnvironmentalProblemsMajor >= 4, na.rm = TRUE)
n_env <- sum(!is.na(data$EnvironmentalProblemsMajor))
prop_test_z(env_concern, n_env, 0.80, "Proportion Test: Environmental Problems Major (≥80% score 4 or 5)")

# ==============================
# Goodness-of-Fit Tests (χ²)
# ==============================

# Goodness-of-Fit Test 1: RegularRecycle Distribution
if (sum(!is.na(data$RegularlyRecycle)) > 0) {
  observed <- table(data$RegularlyRecycle)
  expected_probs <- c(0.10, 0.15, 0.25, 0.30, 0.20) # Never, Rarely, Sometimes, Often, Always
  n <- sum(observed)
  expected <- n * expected_probs
  gof <- chisq.test(observed, p = expected_probs)
  cat("\nChi-square Goodness-of-Fit Test: RegularRecycle Distribution\n")
  print(gof)
  cat("Expected Frequencies:\n")
  print(expected)
  cat("Conclusion:", ifelse(gof$p.value < 0.05, 
                            "Reject H0: Distribution differs from expected.", 
                            "Fail to reject H0: Distribution matches expected."), "\n")
}

# Goodness-of-Fit Test 2: EnvironmentalProblemsMajor Distribution
if (sum(!is.na(data$EnvironmentalProblemsMajor)) > 0) {
  observed <- table(data$EnvironmentalProblemsMajor)
  expected_probs <- c(0.05, 0.10, 0.15, 0.30, 0.40) # Strongly Disagree to Strongly Agree
  n <- sum(observed)
  expected <- n * expected_probs
  gof <- chisq.test(observed, p = expected_probs)
  cat("\nChi-square Goodness-of-Fit Test: EnvironmentalProblemsMajor Distribution\n")
  print(gof)
  cat("Expected Frequencies:\n")
  print(expected)
  cat("Conclusion:", ifelse(gof$p.value < 0.05, 
                            "Reject H0: Distribution differs from expected.", 
                            "Fail to reject H0: Distribution matches expected."), "\n")
}

# ==============================
# Test of Independence (Fisher’s Exact Test)
# ==============================

# Test: Recycling Habits vs. Belief in Individual Impact
if (sum(!is.na(data$RegularlyRecycle) & !is.na(data$IndividualActionsImpact)) > 0) {
  cont_table <- table(data$RegularlyRecycle, data$IndividualActionsImpact)
  cat("\nFisher’s Exact Test: Recycling Habits vs. Belief in Individual Impact\n")
  print("Contingency Table:")
  print(cont_table)
  fisher_test <- fisher.test(cont_table, simulate.p.value = TRUE, B = 2000)
  print(fisher_test)
  cat("Conclusion:", ifelse(fisher_test$p.value < 0.05, 
                            "Reject H0: Variables are associated.", 
                            "Fail to reject H0: Variables are independent."), "\n")
}