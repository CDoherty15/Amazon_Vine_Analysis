# Amazon_Vine_Analysis
Using Google Collab notebooks

## Overview
We are working with Jennifer on her SellBy project, a website that compiles and analyzes reviews for products from certain companies. This project was to analyze Amazon reviews written by members of the paid Amazon Vine program. The Vine program is a service that allows manufacturers and publishers to receive reviews for their products. 
For this project, we looked at the [Video Game](https://s3.amazonaws.com/amazon-reviews-pds/tsv/amazon_reviews_us_Video_Games_v1_00.tsv.gz) review data set (link to download dataset). We used PySpark to perform our ETL process, to extract the data from an Amazon S3 bucket, to transform the data Google Colab notebooks, and created an AWS RDS Database to load the dataset into SQL to further analyze the data. The extra tables that were made can be seen in this repository and in the Results section below.

## Results
First thing was to upload the data and create a dataframe to look at all the data we are provided:
![video_game_rev](https://user-images.githubusercontent.com/79118630/122624505-74d49180-d06e-11eb-8696-1d90d9f36721.png)
- We can now see all the columns we have to work with. The program is only in the US, and right now we are mainly concnerned with review totals and whether or not the reviewer is someone is or is not a Vine reviewer. So we create the `vine_table` (`vine_table.csv`) and use the columns: `review_id, star_rating, helpful_votes, total_votes, vine, verified_purchase`
### Transforming Review DataFrame
- After dropping and rows wil null values and duplicate rows, we are left with 1785997 rows of data. From here, we filtered the data to only return rows where `total_votes` was greater than or equal to 20 to be helpful for the future to avoid divisional errors and for validity. Items with only a few reviews are not necessarily important right now. We are now left with 65379 rows of data. 
- Next we filtered the updated table to only return rows where the review has greater than or 50% of `helpful_votes`. We really only want to look at reviews that people think were helpful since those are the ones that people will read the most, and prioritizes to the company what consumers are wanting help with or happy with. Simply dividing the helpful_votes by the total_votes, for each review, we can filter out the ones that are less than 50% and we are returned with 40565 rows of data.
- We have transformed our data enough, now it is time to breakdown the Vine and non-Vine reviews.
### Vine vs Non-Vine Reviews
We will look at 3 things: the total count of reviews, how many were 5 stars, and the percentage of how many those reviews were 5 stars.
#### Vine reviews 
![vine_yes_5star](https://user-images.githubusercontent.com/79118630/122625409-034b1200-d073-11eb-8a45-cee47e6634b2.png) 
#### non-Vine reviews 
![vine_no_5star](https://user-images.githubusercontent.com/79118630/122625435-21187700-d073-11eb-95bc-2ca5099cbd47.png)

- We had over 40,000 reviews when we were done filtering our data, and yet less 100 of those reviews were Vine reviewers. We can also see though, that close to 50 (48) gave 5-star reviews, over 51% of Vine reviewers gave products 5 stars. 
- With such a low total for Vine reviews, the non-Vine reviews had over 40,400 reviews. Of those 40K+ views, over 15,600 of them were 5-stars. So just about 39% of the non-Vine reviewers submitted 5-star reviews. 

## Summary
- Reviews that had less than 20 votes were deemed as unnecessary because those reviews weren't viewed, or really did not have a significant impact. Then out of those total votes, if a review's total votes were less than 50% helpful, those aren't as a big concern to the company since nobody is really looking at that review. Plus it helps the company look at what they are doing well or what a major concern is from the consumer. Starting with a total of 1,785,997 reviews, filtering down to 40,565, which is 2.27% of the data (40565/1785997 = 0.0227).
- Looking at the percentages, one could say the reviews from the Vine program are skewing the review results because over half of the Vine reviews were 5-stars. However, less than a 100 of these reviews were submited by those in the Vine program. Currently we are looking at over 40,500 reviews, the Vine reviews make up less than 1%, in-fact make up less than half a percent. We could say that the group of non-Vine reviews skew the data as compared to the Vine reviewers, but only about 39% of the non-Vine reviews are 5 stars. This is still a fair percentage and helpful to note that a little less than two-fifths of non-Vine reviews are 5-stars
- However, I would say that this sample that we used of the total population is not sufficient. We are above the statistics norm of over 30 observations, but we are only looking at a sample that is less than 2.5%. One future suggestion would to relax the original filters. For instance, if we change our total votes filter to just 15 and/or 10, keeping the helpful votes percentage the same, we get 59466 rows with 15 and 98075 with 10. With 15 total votes, the sample is only 3.33% of the population and with 10 total votes, the sample is 5.49% of the population. These changes aren't drastic but they can help validate the Vine and non-Vine results more in-depth. This is challenging since a review that only recieves 10 votes is not being interacted with at all, but we kept our helpful vote requirement the same, which shows that even though not many people interacted with the review, over 50% of the people who did found it helpful.
- Another suggestion would be to create a table of a break down of the star count for both Vine and non-Vine reviewers. This will be more effective to see if there is a good variance of the different star ratings. We know that over half of the Vine reviewers put 5-stars, we can say that Vine reviewers skew the data star rating higher because a majority of them are 5-stars. Close to two-fifths of the non-Vine reviewers put 5-stars. If this was a perfectly balanced data set, then each star would only have 1/5 of the votes, so an argument that non-Vine reviewers are skewing the data upwards can also be made, just at a slower rate and less of an impact. 

All of the SQL queries can be found in the `Vine_Review_Analysis.sql` file
