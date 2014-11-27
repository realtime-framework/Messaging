package preferences;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import java.util.ArrayList;

public class PreferencesManager {

	private SharedPreferences settings;

    public static String USER = "USER";
    public static String CHANNELS = "CHANNELS";

	private static PreferencesManager preferencesManagerManager;
	
	private PreferencesManager(SharedPreferences sp) {
		settings = sp;
	}

	public static PreferencesManager getInstance(Context ctx) {
		if (preferencesManagerManager == null) {
		    preferencesManagerManager = new PreferencesManager(PreferenceManager.getDefaultSharedPreferences(ctx));
		}
		return preferencesManagerManager;
	}

    public String loadUser(){
        return settings.getString(USER,null);
    }

    public void saveUser(String novaVersao){
        SharedPreferences.Editor e = settings.edit();
        e.putString(USER,novaVersao);
        e.commit();
    }

    public ArrayList<String> loadChannels(){
        String channels = settings.getString(CHANNELS,null);
        if(channels == null)
        {
            return new ArrayList<String>();
        }

        String[] parts = channels.split(",");

        ArrayList<String> list = new ArrayList<String>();

        for (String channel : parts) {
            list.add(channel);
        }
        return list;
    }

    public void saveChannels(ArrayList<String> channels){
        SharedPreferences.Editor e = settings.edit();
        StringBuilder channelsString = new StringBuilder();

        for (String channel : channels) {
            channelsString.append(channel + ",");
        }

        e.putString(CHANNELS,channelsString.toString());
        e.commit();
    }
}
