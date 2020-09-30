package com.hwloc.lstopo;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RadioButton;
import android.widget.Spinner;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

// Create a window to choose the filter to download topology
public class Options extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        setContentView(R.layout.options);
        final Context activity = this;
        final Button apply = findViewById(R.id.apply);
        final RadioButton logicalIndexes = findViewById(R.id.indexes_logical);
        final RadioButton physicalIndexes = findViewById(R.id.indexes_physical);
        final RadioButton ioObjectsWhole = findViewById(R.id.IO_object_whole);
        final RadioButton ioObjectsNone = findViewById(R.id.IO_object_none);
        final CheckBox noFactorize = findViewById(R.id.no_factorize);
        final CheckBox includeDisallowed = findViewById(R.id.include_disallowed);
        final CheckBox noLegend = findViewById(R.id.no_legend);
        final ArrayList<String> options = new ArrayList<>();

        // Set windows size
        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        int width = dm.widthPixels;
        int height = dm.heightPixels;
        getWindow().setLayout((int) (width * 0.8), (int) (height * 0.8));

        apply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(logicalIndexes.isChecked())
                    options.add("-l");
                else if(physicalIndexes.isChecked())
                    options.add("-p");

                if(ioObjectsNone.isChecked())
                    options.add("--no-io");
                else if(ioObjectsWhole.isChecked())
                    options.add("-whole-io");

                if(noFactorize.isChecked())
                    options.add("--no-factorize");
                if(includeDisallowed.isChecked())
                    options.add("--disallowed");
                if(noLegend.isChecked())
                    options.add("--no-legend");

                // Send the options back to mainActivity
                Intent returnIntent = new Intent();
                returnIntent.putStringArrayListExtra("options", options);
                setResult(RESULT_OK, returnIntent);
                finish();
            }
        });
    }
}
