import feed.Feed;
import httpRequest.httpRequester;
import namedEntity.heuristic.*;
import namedEntity.StringProcesser;
import parser.RedditParser;
import parser.RssParser;
import parser.SubscriptionParser;
import subscription.SingleSubscription;
import subscription.Subscription;

import java.util.ArrayList;
import java.util.List;

public class FeedReaderMain {

	private static void printHelp(){
		System.out.println("Please, call this program in correct way: FeedReader [-ne]");
	}
	
	public static void main(String[] args) {
		System.out.println("************* FeedReader version 1.0 *************");
		if (args.length >= 2) {
			printHelp();
			return;
		} 	

		// Instaciamos los objetos
		SubscriptionParser subscriptionParser = new SubscriptionParser();
		httpRequester req = new httpRequester();
		RssParser rssParser = new RssParser();
		RedditParser redditParser = new RedditParser();

		// Seteamos los parametros desde subscriptions.json
		subscriptionParser.setParams();

		// Instanciamos el objeto subscriptions
		Subscription subscriptions = subscriptionParser.getSubscription();

		if (args.length == 0) {

			// Iteramos por la lista de subscripsiones
			for(int i = 0 ; i < subscriptions.getSubListSize() ; i++){
				
				// Obtenemos la i-esima subscripcion
				SingleSubscription subscription = subscriptions.getSingleSubscription(i);

				// Iteramos sobre la lista de feeds
				for(int j = 0 ; j < subscription.getUlrParamsSize() ; j++){
					
					// Si el tipo de url es rss, parseamos con RssParser, 
					// si es de tipo reddit, parseamos con RedditParser
					if(subscription.getUrlType().equals("rss")){
						
						String xmlString = req.getFeedRss(subscription.getFeedToRequest(j)); 
						System.out.println(xmlString);
						}	/*Feed xmlFeed = rssParser.setFeed(xmlString);
						System.out.println("\n---" + subscription.getUlrParams(j) + "---\n");
						xmlFeed.prettyPrint();
						
					} else if(subscription.getUrlType().equals("reddit")){
						String redditString = req.getFeedReedit(subscription.getFeedToRequest(j));
						Feed redditFeed = redditParser.setFeed(redditString);
						redditFeed.prettyPrint();
					}*/
				}	
			}
			
			
		} else if (args.length == 1){

			List<String> candidates = new ArrayList<String>();

			// Iteramos por la lista de subscripsiones
			for(int i = 0 ; i < subscriptions.getSubListSize() ; i++){
				
				// Obtenemos la i-esima subscripcion
				SingleSubscription subscription = subscriptions.getSingleSubscription(i);

				
				// Iteramos sobre la lista de feeds
				for(int j = 0 ; j < subscription.getUlrParamsSize() ; j++){
					
					// Si el tipo de url es rss, parseamos con RssParser, 
					// si es de tipo reddit, parseamos con RedditParser
					if(subscription.getUrlType().equals("rss")){
						
						String xmlString = req.getFeedRss(subscription.getFeedToRequest(j)); 
						Feed xmlFeed = rssParser.setFeed(xmlString);

						StringProcesser strProc = new StringProcesser(xmlFeed.toString());
						strProc.processString();
						candidates.addAll(strProc.filterCandidates(strProc.getString()));	
						
					} else if(subscription.getUrlType().equals("reddit")){
						String redditString = req.getFeedReedit(subscription.getFeedToRequest(j));
						Feed redditFeed = redditParser.setFeed(redditString);

						StringProcesser strProc = new StringProcesser(redditFeed.toString());
						strProc.processString();
						candidates.addAll(strProc.filterCandidates(strProc.getString()));	

					}
				}	
			}
			QuickHeuristic.main(candidates);
		}
	}
}
