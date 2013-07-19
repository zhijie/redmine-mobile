package com.resolr.redminemobileforandroid;

import android.os.Bundle;
import android.app.Activity;
import android.view.Menu;

public class ProjectListActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_project_list);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.activity_project_list, menu);
        return true;
    }
}
