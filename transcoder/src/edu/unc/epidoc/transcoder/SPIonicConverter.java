/*
 * SPIonicConverter.java
 *
 * (c) Michael Jones <mdjone2@uky.edu>
 * This software is licensed under the terms of the GNU LGPL.
 * See http://www.gnu.org/licenses/lgpl.html for details.
 */

package edu.unc.epidoc.transcoder;

import java.io.*;
import java.lang.*;
import java.util.Properties;
import java.util.StringTokenizer;

/**
 *
 * @author  Michael Jones
 * @version
 */
public class SPIonicConverter implements Converter {

    /** Creates new SPIonicConverter */
    public SPIonicConverter() {
        sgp = new Properties();
        try {
            Class c = this.getClass();
            sgp.load(c.getResourceAsStream("SPIonicConverter.properties"));
        }
        catch (Exception e) {
        }
    }

    private Properties sgp;
    StringBuffer strb = new StringBuffer();
    private static final String ENCODING = "ASCII";
    private static final String LANGUAGE = "grc";
    private static final String UNRECOGNIZED_CHAR = "?";
    private String unrec = UNRECOGNIZED_CHAR;

    public String convertToCharacterEntity(String in) {
        String out;
        if (in.indexOf('_')>0 && in.length()>1) {
            strb.delete(0,strb.length());
            String[] elements = split(in);
            String temp = sgp.getProperty(elements[0]);
            for (int i=0;i<elements.length;i++)
               strb.append(sgp.getProperty(elements[i]));
            out = strb.toString();
        }
        else
            out = sgp.getProperty(in, in);
        strb.delete(0,strb.length());
        char[] chars = out.toCharArray();
        for (int i=0;i<chars.length;i++) {
            if (Character.getNumericValue(chars[i]) > 126) {
                strb.append("&#");
                strb.append(Character.getNumericValue(chars[i]));
                strb.append(";");
            }
            else {
                strb.append(chars[i]);
            }
        }
        return strb.toString();
    }

    public String convertToString(String in) {
        if (in.indexOf('_')>0 && in.length()>1) {
	    String temp;
	    String narrowWide;
	    String[] elements = split(in);
	    strb.delete(0,strb.length());
	    if (isCharacterNarrow(elements[0])) 
		narrowWide = "narrow";
	    else
		narrowWide = "wide";
	    temp = elements[1];
	    if (elements.length == 2) {
		temp += "_" + narrowWide;
		if (sgp.getProperty(temp) != null) {
		    strb.append(sgp.getProperty(elements[0], unrec) + sgp.getProperty(temp, unrec));
		    for (int i=2;i<elements.length;i++)
			strb.append(sgp.getProperty(elements[i], unrec));
		}
		else {
		    for (int i=0; i<elements.length;i++)
			strb.append(sgp.getProperty(elements[i], unrec));
		}
	    }
	    else {
		temp += "_" + elements[2] + "_" + narrowWide;
		if (sgp.getProperty(temp) != null) {
		    strb.append(sgp.getProperty(elements[0], unrec) + sgp.getProperty(temp, unrec));
		    for (int i=3;i<elements.length;i++)
			strb.append(sgp.getProperty(elements[i], unrec));
		}
		else {
		    for (int i=0; i<elements.length;i++)
			strb.append(sgp.getProperty(elements[i], unrec));
		}
	    }
	    return strb.toString();
	}
        else {
            if (in.length() > 1)
                return sgp.getProperty(in, unrec);
            else
                return sgp.getProperty(in, in);
        }
    }

    private String[] split(String str) {
        StringTokenizer st = new StringTokenizer(str, "_");
        int tokenCount = st.countTokens();
        String[] result = new String[tokenCount];
        for (int i = 0; i < tokenCount; i++) {
            result[i] = st.nextToken();
        }
        return result;
    }

    private boolean isCharacterNarrow(String ch) {
	if (ch.equals("iota") || ch.equals("epsilon")) {
	    return true;
	}
	else
	    return false;
    }
  
    public Object getProperty(String name) {
        return null;
    }
    
    public void setProperty(String name, Object value) {
        if (name.equals("suppress-unrecognized-characters")) {
            String val = (String)value;
            if (val.equals("true"))
                unrec = "";
            else
                val = UNRECOGNIZED_CHAR;
        }
    }

    public String getEncoding() {
        return new String(ENCODING);
    }
    
    public boolean supportsLanguage(String lang) {
        return LANGUAGE.equals(lang);
    }
}
