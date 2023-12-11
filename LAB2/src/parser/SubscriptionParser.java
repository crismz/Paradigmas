package parser;

import java.nio.file.Paths;
import subscription.SingleSubscription;
import subscription.Subscription;

import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
/*
 * Esta clase implementa el parser del  archivo de suscripcion (json)
 * Leer https://www.w3docs.com/snippets/java/how-to-parse-json-in-java.html
 * */

public class SubscriptionParser extends GeneralParser{
 
    private Subscription subscriptions;

    public void setParams(){
        try {
            String filepath = Paths
                    .get("")
                    .toAbsolutePath()
                    .toString() + "/config/subscriptions.json";
            parseJSONFile("../config/subscriptions.json");
            
            // Creamos una nueva clase subscriptions
            Subscription subscriptions = new Subscription(filepath);

            // Extraemos datos del json
            JSONArray array = (JSONArray) this.JSONFile.get("subscriptions");
            int length;
            SingleSubscription subscription;
            JSONObject newsub;
            JSONArray paramsArray;
            String url;
            String type;

            for (int i=0; i<array.length(); i++){
                // obtenemos los datos para cada singlesubscription
                newsub = (JSONObject) array.get(i);
                paramsArray = newsub.getJSONArray("urlParams");
                subscription = new SingleSubscription(null, null, null);
                
                length = paramsArray.length();
                for (int j=0; j < length; j++){
                    // Agregamos los parametros
                    subscription.setUlrParams(paramsArray.getString(j));
                }

                url = newsub.getString("url");
                type = newsub.getString("urlType");
                
                // Seteamos la single subscription
                subscription.setUrl(url);
                subscription.setUrlType(type);
                // La agregamos a la clase subscriptions
                subscriptions.addSingleSubscription(subscription);
            }            

            this.subscriptions = subscriptions;

        } catch (JSONException e) {
                e.getStackTrace();
                System.out.println(e);
        }
    }

    public Subscription getSubscription(){
        return this.subscriptions;
    }

}
