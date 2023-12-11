package parser;
import java.io.FileReader;
import java.io.IOException;
import java.io.StringReader;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import java.io.FileNotFoundException;

import org.w3c.dom.*;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.json.JSONException;

/*Esta clase modela los atributos y metodos comunes a todos los distintos tipos de parser existentes en la aplicacion*/
public abstract class GeneralParser {
    public JSONObject JSONFile;    
    public JSONObject redditJSON;
    public Document XMLDocument;

    public void parseJSONFile(String filepath){
        try {
            FileReader file = new FileReader(filepath);
            JSONObject obj = new JSONObject(new JSONTokener(file));
            this.JSONFile = obj;
        } catch (FileNotFoundException e) {
            System.out.println("file not found");
            e.printStackTrace();
        } catch (JSONException e) { 
            System.out.println("JSONTokener error");
            e.printStackTrace();
        }
    }

    public void parseXML(String xmlString){
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();

        try {
            dbf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
    
            DocumentBuilder builder = dbf.newDocumentBuilder();
    
            this.XMLDocument = builder.parse(new InputSource(new StringReader(xmlString)));
        } catch (SAXException | IOException | ParserConfigurationException e) {
            throw new RuntimeException(e);
        }
    }

        public void parseReddit(String redditString) {
            JSONObject obj = new JSONObject(redditString);
            
            this.redditJSON = obj; 
        }
}

