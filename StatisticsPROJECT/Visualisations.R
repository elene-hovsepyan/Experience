# Install and load required packages
required_packages <- c("dplyr", "ggplot2", "corrplot")
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
    "I bring my own reusable bags or containers when shopping.",
    "I try to reduce water and electricity use at home.",
    "I avoid single-use plastics whenever I can.",
    "I actively seek information about environmental issues.",
    "I believe environmental problems are a major issue in Armenia.",
    "I believe recycling practices have evolved in Armenia in the past 5 years.",
    "I believe that the items thrown in the recycling bins are actually recycled.",
    "I feel that individual actions can make a real impact on the environment.",
    "I think environmental topics are discussed enough in Armenian schools/media.",
    "Would you recycle if there were more recycling bins in Armenia?"
  ) %>%
  rename(
    RegularlyRecycle = "I regularly recycle items like paper, plastic, and glass.",
    ReusableBags = "I bring my own reusable bags or containers when shopping.",
    ReduceWaterElectricity = "I try to reduce water and electricity use at home.",
    AvoidSingleUsePlastics = "I avoid single-use plastics whenever I can.",
    ActivelySeekInfo = "I actively seek information about environmental issues.",
    EnvironmentalProblemsMajor = "I believe environmental problems are a major issue in Armenia.",
    RecyclingEvolved = "I believe recycling practices have evolved in Armenia in the past 5 years.",
    RecyclingActuallyRecycled = "I believe that the items thrown in the recycling bins are actually recycled.",
    IndividualActionsImpact = "I feel that individual actions can make a real impact on the environment.",
    EnvironmentalTopicsDiscussed = "I think environmental topics are discussed enough in Armenian schools/media.",
    MoreBinsRecycle = "Would you recycle if there were more recycling bins in Armenia?"
  )

# Convert ordinal variables to numeric
ordinal_vars <- c(
  "RegularlyRecycle", "ReusableBags", "ReduceWaterElectricity", "AvoidSingleUsePlastics",
  "ActivelySeekInfo", "EnvironmentalProblemsMajor", "RecyclingEvolved",
  "RecyclingActuallyRecycled", "IndividualActionsImpact", "EnvironmentalTopicsDiscussed"
)
data[ordinal_vars] <- lapply(data[ordinal_vars], as.numeric)

# Convert categorical variable to factor
data$MoreBinsRecycle <- factor(data$MoreBinsRecycle, levels = c("Yes", "Maybe", "No"))

# Data validation
if (nrow(data) == 0) stop("Error: Data frame is empty.")
required_cols <- c("RegularlyRecycle", "EnvironmentalProblemsMajor", "RecyclingEvolved", 
                   "ActivelySeekInfo", "MoreBinsRecycle", "IndividualActionsImpact",
                   "ReusableBags", "ReduceWaterElectricity", "AvoidSingleUsePlastics",
                   "RecyclingActuallyRecycled", "EnvironmentalTopicsDiscussed")
missing_cols <- setdiff(required_cols, colnames(data))
if (length(missing_cols) > 0) stop(paste("Error: Missing columns:", paste(missing_cols, collapse = ", ")))

# Compute eco_score for correlation heatmap
data$eco_score <- data$RegularlyRecycle + data$ReusableBags + data$ReduceWaterElectricity + data$AvoidSingleUsePlastics

# ==============================
# Visualizations
# ==============================

# Box plot: ActivelySeekInfo
p_box <- ggplot(data, aes(y = ActivelySeekInfo)) +
  geom_boxplot(fill = "darkseagreen1") +
  labs(title = "Box Plot: Actively Seek Information about Environmental Issues", y = "Score (1-5)") +
  theme_minimal()
ggsave("boxplot_seek_info.png", plot = p_box, width = 6, height = 4)
print(p_box)

# Bar plot: RecyclingEvolved
p_rec_evolved <- ggplot(data, aes(x = factor(RecyclingEvolved))) +
  geom_bar(fill = "darkseagreen") +
  labs(title = "Bar Plot: Belief that Recycling Practices Evolved in Armenia", x = "Score (1-5)", y = "Count") +
  theme_minimal()
ggsave("barplot_recycling_evolved.png", plot = p_rec_evolved, width = 6, height = 4)
print(p_rec_evolved)

# Bar plot: RecyclingActuallyRecycled
p_rec_actually <- ggplot(data, aes(x = factor(RecyclingActuallyRecycled))) +
  geom_bar(fill = "plum1") +
  labs(title = "Bar Plot: Belief that Items in Recycling Bins are Actually Recycled", x = "Score (1-5)", y = "Count") +
  theme_minimal()
ggsave("barplot_recycling_actually.png", plot = p_rec_actually, width = 6, height = 4)
print(p_rec_actually)

# Line graph: Average RegularlyRecycle by EnvironmentalProblemsMajor
avg_recycle_by_belief <- data %>%
  group_by(EnvironmentalProblemsMajor) %>%
  summarise(AvgRecycle = mean(RegularlyRecycle, na.rm = TRUE))
p_line1 <- ggplot(avg_recycle_by_belief, aes(x = EnvironmentalProblemsMajor, y = AvgRecycle)) +
  geom_line(color = "orchid4") +
  geom_point(color = "orchid4") +
  labs(title = "Line Graph: Average Recycling Frequency by Environmental Concern",
       x = "Belief Score (Environmental Problems Major)", y = "Average Recycling Score") +
  theme_minimal()
ggsave("linegraph_recycle_by_belief.png", plot = p_line1, width = 6, height = 4)
print(p_line1)

# Line graph: Average EnvironmentalProblemsMajor by RegularlyRecycle
avg_belief_by_recycle <- data %>%
  group_by(RegularlyRecycle) %>%
  summarise(AvgBelief = mean(EnvironmentalProblemsMajor, na.rm = TRUE))
p_line2 <- ggplot(avg_belief_by_recycle, aes(x = RegularlyRecycle, y = AvgBelief)) +
  geom_line(color = "darkseagreen4") +
  geom_point(color = "darkseagreen4") +
  labs(title = "Line Graph: Mean Belief Scores Across Recycling Frequency",
       x = "Recycling Frequency Score", y = "Average Belief Score (Environmental Problems)") +
  theme_minimal()
ggsave("linegraph_belief_by_recycle.png", plot = p_line2, width = 6, height = 4)
print(p_line2)

# Line graph: Average RegularlyRecycle by IndividualActionsImpact
avg_behavior_by_belief <- data %>%
  group_by(IndividualActionsImpact) %>%
  summarise(AvgRecycle = mean(RegularlyRecycle, na.rm = TRUE))
p_line3 <- ggplot(avg_behavior_by_belief, aes(x = IndividualActionsImpact, y = AvgRecycle)) +
  geom_line(color = "purple4") +
  geom_point(color = "purple4") +
  labs(title = "Line Graph: Mean Recycling Behavior Across Belief in Individual Impact",
       x = "Belief Score (Individual Actions Impact)", y = "Average Recycling Score") +
  theme_minimal()
ggsave("linegraph_behavior_by_belief.png", plot = p_line3, width = 6, height = 4)
print(p_line3)

# Scatterplot: RegularlyRecycle vs. EnvironmentalProblemsMajor
p_scatter1 <- ggplot(data, aes(x = RegularlyRecycle, y = EnvironmentalProblemsMajor)) +
  geom_jitter(width = 0.2, height = 0.2, color = "darkblue", alpha = 0.5) +
  labs(title = "Scatterplot: Recycling Frequency vs. Environmental Concern",
       x = "Recycling Frequency Score", y = "Environmental Concern Score") +
  theme_minimal()
ggsave("scatterplot_recycle_vs_concern.png", plot = p_scatter1, width = 6, height = 4)
print(p_scatter1)

# Scatterplot: RecyclingEvolved vs. ActivelySeekInfo
p_scatter2 <- ggplot(data, aes(x = RecyclingEvolved, y = ActivelySeekInfo)) +
  geom_jitter(width = 0.2, height = 0.2, color = "darkred", alpha = 0.5) +
  labs(title = "Scatterplot: Belief in Recycling Evolution vs. Seeking Information",
       x = "Recycling Evolved Score", y = "Actively Seek Information Score") +
  theme_minimal()
ggsave("scatterplot_evolved_vs_seekinfo.png", plot = p_scatter2, width = 6, height = 4)
print(p_scatter2)

# Bar plot for contingency table
contingency_table <- table(data$RegularlyRecycle, data$IndividualActionsImpact)
contingency_data <- as.data.frame(contingency_table)
p_contingency <- ggplot(contingency_data, aes(x = Var1, y = Freq, fill = factor(Var2))) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Recycling Habits by Belief in Individual Impact",
       x = "Recycling Frequency Score", y = "Count", fill = "Belief Score") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
ggsave("chi_independence_barplot.png", plot = p_contingency, width = 6, height = 4)
print(p_contingency)

# Insight Q1 Visualization: Intention-Action Gap
gap_table <- table(data$MoreBinsRecycle, data$RegularlyRecycle >= 4)
gap_table_2x2 <- matrix(c(
  sum(gap_table[c("Maybe", "No"), 1]), sum(gap_table[c("Maybe", "No"), 2]),
  gap_table["Yes", 1], gap_table["Yes", 2]
), nrow = 2, byrow = TRUE)
gap_data <- data.frame(
  Willingness = rep(c("Not Yes", "Yes"), each = 2),
  Recycling = rep(c("Low (RegularlyRecycle < 4)", "High (RegularlyRecycle >= 4)"), 2),
  Count = c(gap_table_2x2[1,1], gap_table_2x2[1,2], gap_table_2x2[2,1], gap_table_2x2[2,2])
)
gap_data <- gap_data %>%
  group_by(Willingness) %>%
  mutate(Percentage = Count / sum(Count) * 100)
p_gap <- ggplot(gap_data, aes(x = Willingness, y = Percentage, fill = Recycling)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Recycling Behavior by Willingness to Recycle if More Bins",
       x = "Willingness (MoreBinsRecycle)", y = "Percentage (%)", fill = "Recycling Behavior") +
  theme_minimal()
ggsave("intention_action_gap_2x2_barplot.png", plot = p_gap, width = 6, height = 4)
print(p_gap)

# Insight Q2 Visualization: Trust in System vs. Behavior
trust_table <- table(data$RecyclingActuallyRecycled >= 4, data$RegularlyRecycle >= 4)
trust_data <- data.frame(
  Trust = rep(c("Low Trust (RecyclingActuallyRecycled < 4)", "High Trust (RecyclingActuallyRecycled >= 4)"), each = 2),
  Recycling = rep(c("Low Recycling (RegularlyRecycle < 4)", "High Recycling (RegularlyRecycle >= 4)"), 2),
  Count = c(trust_table[1,1], trust_table[1,2], trust_table[2,1], trust_table[2,2])
)
trust_data <- trust_data %>%
  group_by(Trust) %>%
  mutate(Percentage = Count / sum(Count) * 100)
p_trust <- ggplot(trust_data, aes(x = Trust, y = Percentage, fill = Recycling)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Recycling Behavior by Trust in Recycling System",
       x = "Trust Level", y = "Percentage (%)", fill = "Recycling Behavior") +
  theme_minimal()
ggsave("trust_recycling_barplot.png", plot = p_trust, width = 6, height = 4)
print(p_trust)

# Insight Q3 Visualization: Eco-Actions Correlation
cor_matrix <- cor(data[, c("RegularlyRecycle", "ReusableBags", "ReduceWaterElectricity", "AvoidSingleUsePlastics")], use = "complete.obs")
png("eco_actions_corrplot.png", width = 600, height = 400)
corrplot(cor_matrix, method = "color", type = "upper", addCoef.col = "black", tl.col = "black", tl.srt = 45,
         title = "Correlation Matrix of Eco-Actions")
dev.off()

# Insight Q4 Visualization: Environmental Mood
mood_data <- data.frame(
  Mood = c("Skepticism", "Hope", "Pessimism", "Indifference", "Mixed"),
  Proportion = c(107/307, 78/307, 69/307, 31/307, 22/307)
)
p_mood <- ggplot(mood_data, aes(x = Mood, y = Proportion * 100)) +
  geom_bar(stat = "identity", fill = "#A164A2") +
  labs(title = "Environmental Mood Among Young Adults in Yerevan",
       x = "Mood", y = "Percentage (%)") +
  theme_minimal()
ggsave("mood_barplot.png", plot = p_mood, width = 6, height = 4)
print(p_mood)

# Insight Q5 Visualization: Behavior Change Potential
potential <- data %>%
  filter(MoreBinsRecycle %in% c("Yes", "Maybe") & RegularlyRecycle <= 3) %>%
  summarise(n = n(), prop = n / nrow(data))
potential_data <- data.frame(
  Group = c("Potential Recyclers", "Others"),
  Proportion = c(potential$prop, 1 - potential$prop)
)
p_potential <- ggplot(potential_data, aes(x = Group, y = Proportion * 100)) +
  geom_bar(stat = "identity", fill = "slategray2") +
  labs(title = "Proportion of Potential Recyclers in Yerevan",
       x = "Group", y = "Percentage (%)") +
  theme_minimal()
ggsave("potential_recyclers_barplot.png", plot = p_potential, width = 6, height = 4)
print(p_potential)