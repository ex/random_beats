/*------------------------------------*\
 * Weekend 3 Assignment               *
 * A composition by Laurens Rodriguez *
 * 2013 Nov 10                        *  
\*------------------------------------*/
<<< "Assignment_3_EX_Beats.ck" >>>;

// Sound system
SawOsc oscChip => Pan2 pc => dac;
SinOsc oscBass => dac;
TriOsc oscSong => dac;

// Samples used
string samples[3];
me.dir() + "/audio/kick_05.wav" => samples[0];
me.dir() + "/audio/hihat_02.wav" => samples[1];
me.dir() + "/audio/snare_02.wav" => samples[2];

Gain master => dac;
SndBuf kick => master;
SndBuf snare => master;
SndBuf hihat => master;

// Setting samples
samples[0] => kick.read;
0.35 => kick.gain;
kick.samples() => kick.pos;

samples[1] => hihat.read;
0.1 => hihat.gain;
hihat.samples() => hihat.pos;

samples[2] => snare.read;
0.15 => snare.gain;
snare.samples() => snare.pos;

// Muting all
0 => oscChip.gain;
0 => oscBass.gain;
0 => oscSong.gain;

// Allowed notes
[50, 52, 53, 55, 57, 59, 60, 62] @=> int notes[];

// Melodies
[-1, -1, 0, 1, 0, 1, 3, 2, 5, 6, -1, 5, 6, -1, 4, 7, 
 -1, -1, 0, 1, 0, 1, 3, 2, 5, 6, -1, 4, 7, -1, 3, 0 ] @=> int chip[];
  
[0, -1, -1, -1, 2, -1, -1, -1, 0, -1, -1, -1, 3, -1, -1, -1] @=> int bass[];

[-1,1,-1,-1,7,2,-1,-1,-1,1,3,3,4,4,-1,4,2,1,-1,4,5,6,3,1,6,5,7,7,3,-1,2,0,
6,0,5,6,7,7,4,1,0,0,6,-1,1,-1,4,-1,-1,7,0,0,3,4,6,5,2,0,5,2,2,7,5,-1,3,1,
5,4,3,1,-1,0,2,6,3,7,5,1,-1,4,2,-1,4,3,-1,7,-1,7,4,1,2,-1,7,4,-1,6,6,3,-1,
-1,6,2,-1,3,5,2,0,3,4,5,5,2,-1,1,6,-1,3,4,2,-1,7,7,3,1,2,1,6,1,2,0,7,0,5,3,
-1,5,6,1,3,6,-1,7,3,-1] @=> int song[];

0.05 => float VC;
0.2 => float VS;
0.35 => float VB;

0 => int kc; // Index chip pattern
0 => int kb; // Index bass pattern
0 => int ks;
0 => int kk;

// Set the times
now + 40::second => time timeEnd;
now => time timeStart;
0 => float t;

// The random 'song' generator.
Math.srandom( 1 );

0 => float freq;
0 => float vc;
0 => float vs;
0 => float vb;

for ( 0 => int k; now < timeEnd; k++ )
{
    // Play samples
    if ( k % 2 == 0 )
    {
        0 => kick.pos;
        if ( ( k % 8 != 0 ) && ( k % 8 != 6 ) )
        {
            1 => snare.rate;
        }
    }
    if ( ( k % 8 == 0 ) || ( k % 8 == 6 ) )
    {
        0  => snare.pos;        
//        snare.samples() => snare.pos;
//        -1 => snare.rate;
    }
    0 => hihat.pos;
    
    // Play chip tune line
    k % chip.cap() => kc;
    if ( chip[kc] >= 0 )
    {
        Std.mtof( notes[chip[kc]] ) => freq;
        freq * 2 => oscChip.freq;
    }
    Math.sin( t / pi ) => pc.pan;        
    VC * Math.fabs( Math.cos( t / pi ) ) => vc;    
    
    // Play bass line    
    k % bass.cap() => kb;
    if ( bass[kb] >= 0 )
    {
        VB => vb;                                            
        Std.mtof( notes[bass[kb]] ) => freq;
        freq / 2 => oscBass.freq;
    }
    VB * Math.fabs( Math.cos( t / 0.5 * pi ) ) => oscBass.gain;                                    
    
    // Play song line        
    if ( now >= timeStart + 4::second )
    {
        song[kk++] => ks;        
        if ( ks >= 0 )
        {
            VS => vs;                                                            
            Std.mtof( notes[ks] ) => freq;
            freq => oscSong.freq;
        }
        else
        {
            0 => vs;                                                            
        }
        <<< k + ": " + ks >>>;
        if ( kk >= song.cap() )
        {
            0 => kk;
        }
    }
    /*
    Math.random2( -2, notes.cap() - 1 ) => ks;
    if ( ( ks >= 0 ) && ( now >= timeStart + 4::second ) )
    {
        VS => vs;                                                            
        Std.mtof( notes[ks] ) => freq;
        <<< k + ": " + ks >>>;
        freq => oscSong.freq;
    }
    else
    {
        if ( now >= timeStart + 4::second )
        {
            <<< k + ": -1" >>>;        
        }
        0 => vs;                                                            
    }
    */
    if ( now < timeStart + 2::second )
    {
        vc * ( now - timeStart ) / 2::second => vc;
    }
    if ( now > timeEnd - 5::second )
    {
        vs * ( timeEnd - now ) / 5::second => vs;
        vc * ( timeEnd - now ) / 5::second => vc;
        VB * ( timeEnd - now ) / 5::second => oscBass.gain;                                            
        ( timeEnd - now ) / 5::second => master.gain;                                            
    }

    vc => oscChip.gain;                                                            
    vs => oscSong.gain;                                                        
    
    // Advance time
    0.25::second => now;
    t + 11025 => t;
}
<<< "--END--" >>>;