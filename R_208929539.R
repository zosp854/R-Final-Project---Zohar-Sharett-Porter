# טעינת הספריות הנדרשות
library(ggplot2)
library(ggdist)
library(dplyr)
library(tidyr)
library(pROC)

# קריאת הנתונים
df <- read.csv("data.csv")

# הצגת שמות העמודות כדי לוודא שהכל תקין
colnames(df)

#הצגת נתונים מקדימה

# Ensure Self.disclosure_dummy is a factor
df <- df %>%
  mutate(Self.disclosure_dummy = as.factor(Self.disclosure_dummy))

# Reshape data to long format for easy faceted plotting
df_long <- df %>%
  select(Self.disclosure_dummy, 
         Total.feeling.heard, TOTAL.ANT, Avr.intimacy, 
         IOS..Inclusion.of.Ot, Meta_.perceptions_grade, ucla_post_grade_avg) %>%
  pivot_longer(cols = -Self.disclosure_dummy, 
               names_to = "Dependent_Variable", values_to = "Value")

# Boxplot with mean markers for all dependent variables
ggplot(df_long, aes(x = Self.disclosure_dummy, y = Value, fill = Self.disclosure_dummy)) +
  geom_boxplot(alpha = 0.6) +
  stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "yellow") +
  facet_wrap(~Dependent_Variable, scales = "free") + 
  scale_x_discrete(labels = c("Generic Questions", "Self-Disclosure Questions")) +
  labs(title = "Effect of Self-Disclosure on Multiple Dependent Variables",
       x = "Self-Disclosure Condition", y = "Score") +
  theme_minimal()

# Ensure Responsivness_dummy is a factor
df <- df %>%
  mutate(Responsivness_dummy = as.factor(Responsivness_dummy))

# Reshape data to long format
df_long <- df %>%
  select(Responsivness_dummy, 
         Total.feeling.heard, TOTAL.ANT, Avr.intimacy, 
         IOS..Inclusion.of.Ot, Meta_.perceptions_grade, ucla_post_grade_avg) %>%
  pivot_longer(cols = -Responsivness_dummy, 
               names_to = "Dependent_Variable", values_to = "Value")

# Violin plot with mean markers for all dependent variables
ggplot(df_long, aes(x = Responsivness_dummy, y = Value, fill = Responsivness_dummy)) +
  geom_violin(alpha = 0.6) +
  stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "yellow") +
  facet_wrap(~Dependent_Variable, scales = "free") + 
  scale_x_discrete(labels = c("Not Responsive", "Responsive")) +
  labs(title = "Effect of Chatbot Responsiveness on Multiple Dependent Variables",
       x = "Responsiveness Condition", y = "Score") +
  theme_minimal()

#1. התפלגות כללים של ״פילינג הרד״
ggplot(df, aes(x = Total.feeling.heard)) +
  geom_histogram(aes(y = ..density..), bins = 10, fill = "blue", alpha = 0.5) +
  geom_density(color = "red", size = 1) +
  labs(title = "Distribution of Feeling Heard",
       x = "Feeling Heard Score", y = "Density") +
  theme_minimal()

#2.  התפלגות ״פילינג הרד״ לפי סוג השאלה

ggplot(df, aes(x = factor(Self.disclosure_dummy), y = Total.feeling.heard, fill = factor(Self.disclosure_dummy))) +
  geom_boxplot(alpha = 0.6) +
  stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "yellow") +
  scale_x_discrete(labels = c("Generic Questions", "Self-Disclosure Questions")) +
  labs(title = "Effect of Self Disclosure on Feeling Heard",
       x = "Self Disclosure Condition", y = "Feeling Heard Score") +
  theme_minimal()

#3.  התפלגות ״פילינג הרד״ לפי תגבותיות הצ׳ט 

ggplot(df, aes(x = factor(Responsivness_dummy), y = Total.feeling.heard, fill = factor(Responsivness_dummy))) +
  geom_violin(alpha = 0.6) +
  stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "yellow") +
  scale_x_discrete(labels = c("Not Responsive", "Responsive")) +
  labs(title = "Effect of Chatbot Responsiveness on Feeling Heard",
       x = "Responsiveness Condition", y = "Feeling Heard Score") +
  theme_minimal()

#4. הצגה גרפית של ״פילינג הרד״ לפי סוג שאלה, בשימוש ggdist

ggplot(df, aes(x = factor(Self.disclosure_dummy), y = Total.feeling.heard, fill = factor(Self.disclosure_dummy))) +
  stat_halfeye(adjust = 0.5, width = 0.6, .width = 0.95, justification = -0.2) +
  geom_boxplot(width = 0.2, outlier.shape = NA, alpha = 0.5) +
  stat_summary(fun = "mean", geom = "point", shape = 23, size = 3, fill = "yellow") +
  scale_x_discrete(labels = c("Generic", "Self-Disclosure")) +
  labs(title = "Feeling Heard by Self Disclosure Condition",
       x = "Self Disclosure Condition", y = "Feeling Heard Score") +
  theme_minimal()

#Research Question - How do chatbot responsiveness and self-disclosure affect the feeling of being heard?

#עיבוד מקדים

df_clean <- df %>%
  select(Total.feeling.heard, Self.disclosure_dummy, Responsivness_dummy) %>% 
  mutate(
    Self.disclosure_dummy = as.factor(Self.disclosure_dummy),
    Responsivness_dummy = as.factor(Responsivness_dummy)
  )

# בדיקה לווידוא שהכל תקין
str(df_clean)
summary(df_clean)


df_clean <- df_clean %>%
  # יצירת משתנה בינארי "High_Feeling_Heard" לרגרסיה לוגיסטית
  mutate(High_Feeling_Heard = ifelse(Total.feeling.heard >= median(Total.feeling.heard, na.rm = TRUE), 1, 0)) %>%
  
  # המרת המשתנה הבינארי לסוג factor (קטגוריאלי) כדי להתאים לרגרסיה לוגיסטית
  mutate(High_Feeling_Heard = as.factor(High_Feeling_Heard))

df_clean

summary(df_clean$High_Feeling_Heard)  # מציג סטטיסטיקות סיכום
table(df_clean$High_Feeling_Heard)  # מציג ספירת משתתפים בכל קבוצה (0/1)

#יצירת פונקציה שסופרת את אחוז המשתתפים עם ״פיליג הרד״ גבוה 

calculate_high_feeling_rate <- function(data, threshold = 3) {
  total <- nrow(data)
  high_feeling <- sum(data$Total.feeling.heard > threshold, na.rm = TRUE)
  rate <- (high_feeling / total) * 100
  return(paste("Percentage of participants with high Feeling Heard (>", threshold, "):", round(rate, 2), "%"))
}

calculate_high_feeling_rate(df_clean)

#יצירת פונקציה שסופרת את אחוז המשתתפים עם ״פיליג הרד״ גבוה לפי תנאי הניסוי

calculate_high_feeling_by_group <- function(data, group_var, threshold = 3) {
  data %>%
    group_by(!!sym(group_var)) %>%
    summarise(
      total = n(),
      high_feeling = sum(Total.feeling.heard > threshold, na.rm = TRUE),
      rate = round((high_feeling / total) * 100, 2)
    )
}

# Run the function for Self-Disclosure Condition
calculate_high_feeling_by_group(df_clean, "Self.disclosure_dummy")

# Run the function for Responsiveness Condition
calculate_high_feeling_by_group(df_clean, "Responsivness_dummy")


# ביצוע רגרסיה לינארית מרובה
linear_model <- lm(Total.feeling.heard ~ Self.disclosure_dummy + Responsivness_dummy, data = df_clean)

# הצגת תוצאות המודל
summary(linear_model)

ggplot(df_clean, aes(x = interaction(Self.disclosure_dummy, Responsivness_dummy), y = Total.feeling.heard, fill = interaction(Self.disclosure_dummy, Responsivness_dummy))) +
  geom_boxplot(alpha = 0.6) +
  scale_x_discrete(labels = c("Generic & Not Responsive", "Intimate & Not Responsive", "Generic & Responsive", "Intimate & Responsive")) +
  labs(title = "Effect of Self Disclosure and Responsiveness on Feeling Heard",
       x = "Condition", y = "Feeling Heard Score") +
  theme_minimal()


# רגרסיה לוגיסטית
logistic_model <- glm(High_Feeling_Heard ~ Self.disclosure_dummy + Responsivness_dummy, 
                      data = df_clean, family = binomial)

# הצגת תוצאות המודל
summary(logistic_model)


# חיזוי הסתברויות מהמודל
df_clean$predicted_prob <- predict(logistic_model, type = "response")

# יצירת עקומת ROC
roc_curve <- roc(df_clean$High_Feeling_Heard, df_clean$predicted_prob)

# ציור הגרף
plot(roc_curve, col = "blue", main = "ROC Curve for Logistic Regression Model")

auc_value <- auc(roc_curve)
auc_value

