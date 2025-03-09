# Dataset Overview:

The dataset consists of responses from 366 participants who took part in an experiment of a a dialogue that includes self-disclosure in front of reactive AI as a factor affecting feelings of loneliness and anthropomorphism. Each participant was randomly assigned to one of four conditions in a 2X2 design. In the manipulation, participants engaged in a conversation with a chatbot, with each participant interacting under one of the four conditions based on the following variables:

### Self-Disclosure Condition vs. Generic Condition Without Disclosure:

1. Self-Disclosure Condition: Participants were asked to answer three questions that require self-disclosure and involve detailed information about themselves and their lives.
2. Generic Condition Without Disclosure: Participants were asked to answer three generic questions that do not require self-disclosure and focus on technical information about their lives.

### Responsive Chatbot vs. Non-Responsive Chatbot:

1. Responsive Chatbot: The chatbot responded to the participant's answer for each question in an alert and attentive manner. Additionally, the chatbot answered questions about itself and shared information about itself.
2. Non-Responsive Chatbot: The chatbot did not share any information about itself and only provided technical responses to the participant's answers.

In summary, each participant was randomly assigned to one of the following four conditions:

1. Self-Disclosure Condition with Responsive Chatbot
2. Self-Disclosure Condition with Non-Responsive Chatbot
3. Generic Condition with Responsive Chatbot
4. Generic Condition with Non-Responsive Chatbot

Each participant answered questions assessing their loneliness, perception of anthropomorphism, self esteem, meta perceptions perceived feeling of being heard and more.
 
I chose this dataset because, in the original analysis of this experiment, we focused on loneliness and anthropomorphism. However, this project provides an opportunity to expand that analysis by focusing on other measured dependent variables, such as ‘feeling heard.’ This psychological construct refers to the sense of being understood in one’s feelings, thoughts, and needs, which plays a vital role in fostering human connections and enhancing interpersonal relationships. The desire to be understood, or to avoid being misunderstood, is a central goal in interpersonal interactions (Reis et al., 2017). Choosing this line of research allows us to gain deeper insights into user experience in chatbot interactions and explore new dimensions of human-AI communication.

# Research Question: 

How do self-disclosure and chatbot responsiveness influence users' perception of feeling heard in a digital conversation?

# Summary of Regression Results

## Linear Regression

The linear regression model examined the effects of self-disclosure and chatbot responsiveness on participants' perceived feeling of being heard.
* Self-disclosure had a negative effect on feeling heard (B = -0.42, p < 0.001), indicating that participants who were asked intimate questions reported lower levels of feeling heard compared to those who were asked generic questions.

* Chatbot responsiveness had a positive effect (B = 0.35, p = 0.002), meaning that participants interacting with a responsive chatbot reported higher feelings of being heard.

* The model was statistically significant (F(2, 363) = 11.8, p < 0.001), but explained only 6% of the variance in feeling heard (R² = 0.061), suggesting that other factors may contribute to this perception.
These findings indicate that while chatbot responsiveness enhances the perception of being heard, self-disclosure has the opposite effect, possibly due to a lack of reciprocal engagement from the chatbot. However, the relatively low explained variance suggests that additional variables influence this perception.

## Logistic Regression

The logistic regression model analyzed the likelihood of participants reporting high feelings of being heard (above the predefined threshold).

* Self-disclosure significantly decreased the likelihood of reporting high feeling heard (B = -0.568, p = 0.008, OR = 0.57), indicating that participants who answered self-disclosing questions were 43% less likely to perceive high levels of being heard.

* Chatbot responsiveness significantly increased the likelihood of feeling heard (B = 0.7869, p <0.001, OR = 2.2), meaning that participants who interacted with a responsive chatbot were 2.2 times more likely to report high levels of feeling heard.

* The model demonstrated moderate predictive power, with an AUC of 0.63, indicating that it performs better than random chance but does not have strong predictive accuracy.
Overall, the findings suggest that chatbot responsiveness is a significant factor in enhancing perceived feeling heard, while self-disclosure appears to reduce this perception. The model’s moderate predictive power indicates that further research is needed to identify additional factors influencing perceived social presence in chatbot interactions.


Reis, H. T., Lemay Jr, E. P., & Finkenauer, C. (2017). Toward understanding understanding: The importance of feeling understood in relationships. Social and Personality Psychology Compass, 11(3), e12308.
