package parser;

import java.time.Instant;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import feed.Article;
import feed.Feed;

/*
 * Esta clase implementa el parser de feed de tipo reddit (json)
 * pero no es necesario su implemntacion 
 * */

public class RedditParser extends GeneralParser {
    public Feed setFeed(String redditString){
        try {
            this.parseReddit(redditString);

            JSONObject obj = this.redditJSON;

            JSONArray articleArray = obj
                    .getJSONObject("data")
                    .getJSONArray("children");
                
            String feedname = articleArray
                    .getJSONObject(0)
                    .getJSONObject("data")
                    .getString("subreddit");

            Feed feed = new Feed(feedname);

            for(int i = 0 ; i < articleArray.length() ; i++){
                JSONObject data = articleArray.getJSONObject(i).getJSONObject("data");

                String title = data.getString("title");

                String text = data.getString("selftext");

                long unixTimestamp = data.getLong("created_utc");
                Instant instant = Instant.ofEpochSecond(unixTimestamp);

                Date pubDate = Date.from(instant);

                String link = data.getString("url");

                Article article = new Article(title, text, pubDate, link);
                feed.addArticle(article);
            }
            
            return feed;
        } catch (JSONException e) {
            throw new RuntimeException(e);
        }
    }
}
