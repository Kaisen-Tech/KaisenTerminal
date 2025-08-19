package com.kaisentech.terminal

import android.content.pm.PackageManager
import android.os.Bundle
import android.text.Editable
import android.text.SpannableStringBuilder
import android.text.TextWatcher
import android.text.method.ScrollingMovementMethod
import android.view.KeyEvent
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import moe.shizuku.api.ShizukuService
import android.widget.Toast

class MainActivity : AppCompatActivity() {

    private lateinit var terminalOutput: TextView
    private lateinit var terminalInput: EditText

    private val outputBuffer = SpannableStringBuilder()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        terminalOutput = findViewById(R.id.terminal_output)
        terminalInput = findViewById(R.id.terminal_input)

        terminalOutput.movementMethod = ScrollingMovementMethod()

        terminalInput.setOnEditorActionListener { _, _, event ->
            if (event != null && event.keyCode == KeyEvent.KEYCODE_ENTER && event.action == KeyEvent.ACTION_DOWN) {
                processCommand()
                return@setOnEditorActionListener true
            }
            false
        }

        terminalInput.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) {
                if (s.toString().trim().equals("shizuku", ignoreCase = true)) {
                    requestShizukuPermission()
                    terminalInput.setText("")
                }
            }
        })

        appendOutput("Welcome to Kaisen Terminal. Type 'shizuku' to request permissions.\n> ")
    }

    private fun appendOutput(text: String) {
        outputBuffer.append(text)
        terminalOutput.text = outputBuffer
        terminalOutput.post {
            val scrollAmount = terminalOutput.layout.getLineTop(terminalOutput.lineCount) - terminalOutput.height
            if (scrollAmount > 0) {
                terminalOutput.scrollTo(0, scrollAmount)
            } else {
                terminalOutput.scrollTo(0, 0)
            }
        }
    }

    private fun processCommand() {
        val command = terminalInput.text.toString().trim()
        appendOutput(command + "\n")
        terminalInput.setText("")

        if (command.isNotEmpty()) {
            if (command == "clear") {
                outputBuffer.clear()
                appendOutput("Welcome to Kaisen Terminal. Type 'shizuku' to request permissions.\n> ")
            } else if (command == "shizuku") {
                appendOutput("Shizuku permission request initiated.\n> ")
            } else {
                appendOutput("Command not recognized: $command\n> ")
            }
        } else {
            appendOutput("> ")
        }
    }

    private fun requestShizukuPermission() {
        if (!ShizukuService.pingBinder()) {
            appendOutput("Shizuku service is not running. Please start Shizuku Manager.\n> ")
            return
        }

        if (ShizukuService.get().checkSelfPermission() == PackageManager.PERMISSION_GRANTED) {
            appendOutput("Shizuku permission already granted.\n> ")
        } else {
            ShizukuService.get().requestPermission(object : ShizukuService.OnRequestPermissionResultListener {
                override fun onRequestPermissionResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
                    if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                        appendOutput("Shizuku permission granted!\n> ")
                        Toast.makeText(this@MainActivity, "Shizuku permission granted!", Toast.LENGTH_SHORT).show()
                    } else {
                        appendOutput("Shizuku permission denied.\n> ")
                        Toast.makeText(this@MainActivity, "Shizuku permission denied.", Toast.LENGTH_SHORT).show()
                    }
                }
            })
        }
    }
}
