; Advanced Logging Module for PTCGPB

; Log levels as global constants
global LOG_DEBUG := 10
global LOG_INFO := 20
global LOG_WARNING := 30
global LOG_ERROR := 40
global LOG_CRITICAL := 50

; Default minimum log level
global logMinLevel := 20  ; Default to INFO level
global logBasePath := A_ScriptDir . "\..\Logs\"

; Log throttling system to prevent repetitive messages
global logThrottleEnabled := true          ; Enable/disable throttling
global logLastMessages := {}               ; Store last message for each level
global logMessageCounter := {}             ; Count occurrences of each message
global logMessageFirstTime := {}           ; Store timestamp of first occurrence
global logRunCounter := 0                  ; Track run count to reset throttling between runs

; Initialize the logger
InitLogger() {
    global debugMode, logMinLevel, LOG_DEBUG, LOG_INFO, logBasePath, logThrottleEnabled
    
    ; Set log level based on debug mode
    if (debugMode)
        logMinLevel := LOG_DEBUG
    else
        logMinLevel := LOG_INFO
        
    ; Create log directories if they don't exist
    if !FileExist(logBasePath)
        FileCreateDir, %logBasePath%
    
    Log("Logger initialized. Debug mode: " . (debugMode ? "ON" : "OFF"), LOG_INFO)
    Log("Log throttling: " . (logThrottleEnabled ? "ON" : "OFF"), LOG_INFO)
}

; Check if a message should be throttled
ShouldThrottleMessage(message, level) {
    global logThrottleEnabled, logLastMessages, logMessageCounter, logMessageFirstTime, logRunCounter
    
    if (!logThrottleEnabled || level >= LOG_ERROR)
        return false  ; Don't throttle for errors or critical messages
    
    ; Create keys with run counter to separate different runs
    messageKey := logRunCounter . "|" . level . "|" . message
    levelKey := logRunCounter . "|" . level
    
    ; Check if this is the first message at this level for this run
    if (!logLastMessages.HasKey(levelKey)) {
        ; First message at this level for this run
        logLastMessages[levelKey] := message
        logMessageCounter[messageKey] := 1
        logMessageFirstTime[messageKey] := A_TickCount // 1000
        return false  ; Don't throttle the first occurrence
    }
    
    ; If there's a different previous message for this level
    if (logLastMessages[levelKey] != message) {
        ; Log the last occurrence of the previous message
        prevMessageKey := logRunCounter . "|" . level . "|" . logLastMessages[levelKey]
        if (logMessageCounter.HasKey(prevMessageKey) && logMessageCounter[prevMessageKey] > 1) {
            ; Log the previous message with count
            oldMsg := logLastMessages[levelKey] . " (repeated " . logMessageCounter[prevMessageKey] . " times)"
            _ActuallyLogMessage(oldMsg, level)
        }
        
        ; Update to the new message
        logLastMessages[levelKey] := message
        logMessageCounter[messageKey] := 1
        logMessageFirstTime[messageKey] := A_TickCount // 1000
        return false  ; Don't throttle this new message
    }
    
    ; Same message as before, update counter
    if (!logMessageCounter.HasKey(messageKey)) {
        ; First time seeing this message
        logMessageCounter[messageKey] := 1
        logMessageFirstTime[messageKey] := A_TickCount // 1000
        return false  ; Don't throttle the first occurrence
    } else {
        ; We've seen this message before, throttle it
        logMessageCounter[messageKey] += 1
        return true
    }
}

; Reset throttling for a new run
ResetLogThrottling() {
    global logLastMessages, logMessageCounter, logMessageFirstTime, logRunCounter
    
    ; Flush any pending messages
    FlushLogMessages()
    
    ; Increment run counter
    logRunCounter += 1
    
    ; Log the reset event
    Log("Log throttling reset for new run: " . logRunCounter, LOG_INFO)
}

_ActuallyLogMessage(message, level, logCategory := "") {
    global scriptName, debugMode, LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR, LOG_CRITICAL, logMinLevel, logBasePath
    
    ; Determine level name for log entry
    levelName := "INFO"
    if (level == LOG_DEBUG)
        levelName := "DEBUG"
    else if (level == LOG_WARNING)
        levelName := "WARNING"
    else if (level == LOG_ERROR)
        levelName := "ERROR"
    else if (level == LOG_CRITICAL)
        levelName := "CRITICAL"
    
    ; Format the log entry with timestamp, level, and message
    FormatTime, readableTime, %A_Now%, yyyy-MM-dd HH:mm:ss
    logEntry := % "[" readableTime "][" levelName "][" scriptName "] " message
    
    ; Always write to the normal log file
    normalLogFile := logBasePath . "Logs" . scriptName . ".txt"
    FileAppend, % logEntry "`n", %normalLogFile%
    
    ; Additionally write to specific log files if applicable
    if (logCategory != "") {
        ; Use specific category for the log file
        specificLogFile := logBasePath . logCategory . ".txt"
        FileAppend, % logEntry "`n", %specificLogFile%
    }
    else if (level >= LOG_ERROR) {
        ; Errors go to Errors.txt
        errorLogFile := logBasePath . "Errors.txt"
        FileAppend, % logEntry "`n", %errorLogFile%
    }
}

; Main logging function
Log(message, level := 20, logCategory := "") {
    global scriptName, debugMode, LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR, LOG_CRITICAL, logMinLevel, logBasePath
    
    ; Skip logging if below minimum level
    if (level < logMinLevel)
        return
    
    ; Check if this message should be throttled
    if (ShouldThrottleMessage(message, level))
        return
    
    ; Log the message using our helper function
    _ActuallyLogMessage(message, level, logCategory)
}

; Convenience functions for different log levels
LogDebug(message, logCategory := "") {
    Log(message, LOG_DEBUG, logCategory)
}

LogInfo(message, logCategory := "") {
    Log(message, LOG_INFO, logCategory)
}

LogWarning(message, logCategory := "") {
    Log(message, LOG_WARNING, logCategory)
}

LogError(message, logCategory := "") {
    Log(message, LOG_ERROR, logCategory)
}

LogCritical(message, logCategory := "") {
    global discordWebhookURL, discordUserId
    
    Log(message, LOG_CRITICAL, logCategory)
    
    ; Automatically send critical errors to Discord
    if (discordWebhookURL != "")
        LogToDiscord("CRITICAL ERROR: " . message, true, discordUserId)
}

; Category-specific convenience functions
LogGP(message, level := 20) {
    Log(message, level, "GPlog")
}

LogRestart(message, level := 20) {
    Log(message, level, "Restart")
}
LogTrade(message, level := 20) {
    Log(message, level, "Trade")
}
LogGPTest(message, level := 20) {
    Log(message, level, "GPTestLog")
}
LogDiscord(message, level := 20) {
    Log(message, level, "DiscordLog")
}
LogMonitor(message, level := 20) {
    Log(message, level, "MonitorLog")
}

FlushLogMessages() {
    global logLastMessages, logMessageCounter, logRunCounter
    
    ; Log last occurrence of each throttled message
    for key, message in logLastMessages {
        if (InStr(key, logRunCounter . "|")) {
            parts := StrSplit(key, "|")
            if (parts.MaxIndex() >= 2) {
                level := parts[2]
                messageKey := key . "|" . message
                
                if (logMessageCounter.HasKey(messageKey) && logMessageCounter[messageKey] > 1) {
                    ; Log the last occurrence with count
                    _ActuallyLogMessage(message . " (repeated " . logMessageCounter[messageKey] . " times)", level)
                }
            }
        }
    }
}