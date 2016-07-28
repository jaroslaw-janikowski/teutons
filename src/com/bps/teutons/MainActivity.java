package com.bps.teutons;

import android.app.Activity;
import android.view.View;
import android.widget.TextView;
import android.os.Bundle;
import com.bps.teutons.R;
import android.content.res.Resources;

public class MainActivity extends Activity {
	private TextView text_view;
	private String[] actions;
	private int current_string_id = 0;

	protected void onCreate(Bundle bundle){
		super.onCreate(bundle);
		setContentView(R.layout.main);
		text_view = (TextView) findViewById(R.id.text_view);
		Resources res = getResources();
		actions = res.getStringArray(R.array.actions);
		setText(current_string_id);
	}

	private void setText(int id){
		if (id > -1 && id < actions.length){
			current_string_id = id;
			text_view.setText(actions[id]);
		}
	}

	public void onNextButton(View view){
		current_string_id++;
		setText(current_string_id);
	}

	public void onPrevButton(View view){
		current_string_id--;
		setText(current_string_id);
	}
}
