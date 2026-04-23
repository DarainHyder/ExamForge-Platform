/**
 * ExamForge - Real-time Quiz Timer
 */

let timeLeft = 0;
let timerId = null;

function initTimer(minutes) {
    timeLeft = minutes * 60;
    updateDisplay();
    
    timerId = setInterval(() => {
        timeLeft--;
        updateDisplay();
        
        if (timeLeft <= 0) {
            clearInterval(timerId);
            autoSubmit();
        }
        
        // Visual warnings
        const timerEl = document.getElementById('timer');
        if (timeLeft <= 60) {
            timerEl.classList.add('alert-critical');
        } else if (timeLeft <= 300) {
            timerEl.classList.add('alert-warning');
        }
    }, 1000);
}

function updateDisplay() {
    const mins = Math.floor(timeLeft / 60);
    const secs = timeLeft % 60;
    const display = `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
    
    const timerEl = document.getElementById('timer');
    if (timerEl) {
        timerEl.textContent = `${display}`;
    }
}

function autoSubmit() {
    alert("Time's up! Your quiz is being submitted automatically.");
    const submitBtn = document.getElementById('btnSubmitQuiz');
    if (submitBtn) {
        submitBtn.click();
    } else {
        // Fallback for form postback
        document.forms[0].submit();
    }
}
