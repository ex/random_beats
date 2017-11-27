
use MIDI::Simple;

new_score;
set_tempo 500000;  # 1 qn => .5 seconds (500,000 microseconds)
patch_change 1, 8;  # Patch 8 = Celesta

# Now play
n en, n50;
n en, n50;
n en, n50;
n en, n52;
n en, n50;
n en, n52;
n en, n55;
n en, n53;
n en, n59;
n en, n60;
n en, n60;
n en, n59;
n en, n60;
n en, n60;
n en, n57;
n en, n62;
n en, n62;
n en, n62;
n en, n50;
n en, n52;
n en, n50;
n en, n52;
n en, n55;
n en, n53;
n en, n59;
n en, n60;
n en, n60;
n en, n57;
n en, n62;
n en, n62;
n en, n55;
n en, n50;

write_score 'chip.mid';