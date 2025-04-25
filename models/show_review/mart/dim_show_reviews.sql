{{
    config(
        tags=["dim", "show_review"],
        materialized="incremental",
        unique_key=["show_name"],
        schema="mart",
    )
}}


with
    fact_show_reviews as (
        select show_name, critic_sentiment, audience_rating, review, review_type
        from {{ ref("fact_show_reviews") }}
    ),
    averaged_ratings as (
        select
            show_name,
            round(
                avg(cast(critic_sentiment as numeric)), 2
            ) as average_critic_sentiment,
            round(avg(audience_rating), 2) as average_audience_rating,
            count(review) as num_reviews,
            sum(
                case when review_type = 'audience' then 1 else 0 end
            ) as num_audience_reviews,
            sum(
                case when review_type = 'critic' then 1 else 0 end
            ) as num_critic_reviews
        from fact_show_reviews
        group by show_name
    )
select *
from averaged_ratings
