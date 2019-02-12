package com.github.alanli7991.androidlayout

import android.os.Bundle
import android.support.constraint.ConstraintLayout
import android.support.constraint.ConstraintSet
import android.support.v7.app.AppCompatActivity;
import android.view.View

class MainActivity : AppCompatActivity() {

    companion object {
        val PURE_CODE_LAYOUT = true
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (PURE_CODE_LAYOUT) {
            setContentView(createActivityMainUseCode())
        }else {
            setContentView(R.layout.activity_main)
        }

    }

    private fun createActivityMainUseCode() : View {

        val blue = View.inflate(baseContext, R.layout.content_blue, null).apply { id = 1 }
        val yellow = View.inflate(baseContext, R.layout.content_yellow, null).apply { id = 2 }
        //ID set in xlm attribute
        val red = View.inflate(baseContext, R.layout.content_red, null)

        val root = ConstraintLayout(baseContext).apply {
            addView(blue)
            addView(yellow)
            addView(red)
        }


        ConstraintSet().apply {
            constrainHeight(red.id, (100*baseContext.resources.displayMetrics.density).toInt())
            connect(red.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START)
            connect(red.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END)
            connect(red.id, ConstraintSet.BOTTOM, ConstraintSet.PARENT_ID, ConstraintSet.BOTTOM)

            constrainPercentHeight(yellow.id, 0.2f)
            connect(yellow.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START)
            connect(yellow.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END)
            connect(yellow.id, ConstraintSet.BOTTOM, red.id, ConstraintSet.TOP)

            connect(blue.id, ConstraintSet.TOP, ConstraintSet.PARENT_ID, ConstraintSet.TOP)
            connect(blue.id, ConstraintSet.START, ConstraintSet.PARENT_ID, ConstraintSet.START)
            connect(blue.id, ConstraintSet.END, ConstraintSet.PARENT_ID, ConstraintSet.END)
            connect(blue.id, ConstraintSet.BOTTOM, yellow.id, ConstraintSet.TOP)
        }.applyTo(root)
        return root
    }

}
