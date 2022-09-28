<p align="center">
  <img src="https://user-images.githubusercontent.com/26531613/94212619-a4b98480-fea2-11ea-97b5-93938a57abbc.png" height="75%" width="75%">
</p>

&nbsp;
&nbsp;
&nbsp;
&nbsp;

<p align="center">
  <a href="https://apps.apple.com/us/app/ai-stock-forecasts/id1527494965?ign-mpt=uo%3D2">
    <img src="https://user-images.githubusercontent.com/26531613/94211816-85215c80-fea0-11ea-9056-45128e1c4c55.png" height="25%" width="25%">
  </a>
 <p/>
 <p align="center">
    <img src="https://img.shields.io/badge/iOS-15.0+-blue.svg" />
    <img src="https://img.shields.io/badge/Swift-5.5-brightgreen.svg" />
</p>

&nbsp;

## General information about this app

This iOS / iPad app predicts Fortune 100 companies stock price evolution through sentiment analysis. It uses **SwiftUI** for the layout, **Built-in NLTagger + custom CoreML** models for sentiment predictions, **Twitter** and **News-api** as the sources for data analysis.

## Quick presentation of the app

<img width="1403" alt="Screen Shot 2021-05-10 at 8 16 51 PM" src="https://user-images.githubusercontent.com/26531613/117740005-7b4d2f00-b1cd-11eb-996e-5083c51633fb.png">

## How does it work?

For this app, I am using **Twitter** and **News-api** as the sources for my sentiment analysis.

I am performing the company analysis via 120 twitter comments about the company. Those comments are splitted in 2 sets. The first set gathers the 60 most recent tweets about the company (Ex: @apple) and the second set gathers the 60 most recent tweets about the stock (Ex: #AAPL).
As the wording between those 2 sets of comments is very different, I used 2 different models trained on different datasets: IMBD dataset of 50k movie reviews for the first model and the Kaggle Sentiment Analysis on Financial Tweets dataset for the 2nd model.

Then, I fetch the 20 most recent news articles about the company and use the built-in NLTagger to perform the sentiment analysis on those news articles

Finally, I calculate a total score based on the sentiment analysis of those 140 comments

## Third Party components usage

### Fetching Twitter data
Swifter package from https://github.com/mattdonnelly/Swifter

### On the HomeScreen:
Icons made by Icongeek26 from www.flaticon.com

### On the SelectionScreen
I used the custom picker from Stewart Lynch: 
https://www.youtube.com/watch?v=ATgOV70YcI8

### On the ResultScreen:
I used the Circle Control code from this project:
https://medium.com/swlh/replicating-the-apple-card-application-using-swiftui-f472f3947683

I used the StockGraph from this project:
https://trailingclosure.com/recreating-the-strava-activity-graph/

### On the EditScreen:
I used the Field Validator code form this project:
https://github.com/bsorrentino/swiftui-fieldvalidator

## Landing Page & Privacy Policy

You can check the [App Landing Page](https://alexismoulin.github.io) for a complete presentation and the [Privacy Policy Page](https://alexismoulin.github.io/AI-Stock-Forecasts/) for further details on how your data is handled by the application

## Open Source & Copying

I provide the entire source code of this dema app for free. This demo app is licensed under MIT so you can use my code in your app, if you choose.

However, **please do not ship this app** under your own account. Paid or free.
