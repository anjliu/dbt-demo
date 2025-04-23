{{
    config(
        tags=["fact", "show_review"],
        materialized="incremental",
        unique_key=["show_name", "skey"],
        schema='mart'
    )
}}

with
    critic_reviews as (
        select skey, show_name, critic_sentiment, critic_review, created_at
        from {{ ref("stg_critic_reviews") }}
    ),
    audience_reviews as (
        select skey, show_name, audience_rating, audience_review, created_at
        from {{ ref("stg_audience_reviews") }}
    ),
    combined_reviews as (
        select
            skey,
            show_name,
            critic_sentiment,
            null as audience_rating,
            critic_review as review,
            'critic' as review_type,
            created_at
        from critic_reviews
        union all
        select
            skey,
            show_name,
            null as critic_sentiment,
            audience_rating,
            audience_review as review,
            'audience' as review_type,
            created_at
        from audience_reviews
    )
select *
from
    combined_reviews

    /*
This script is equivalent to the following:

SELECT
  skey,
  show_name,
  critic_sentiment,
  NULL AS audience_review,
  critic_review AS review,
  'critic' AS review_type,
  created_at
FROM
  `dbt-demo-project-dev.anjie_staging.stg_critic_reviews`
UNION ALL
SELECT
  skey,
  show_name,
  NULL AS critic_sentiment,
  audience_rating,
  audience_review AS review,
  'audience' AS review_type,
  created_at
FROM
  `dbt-demo-project-dev.anjie_staging.stg_audience_reviews`;

  */
    
