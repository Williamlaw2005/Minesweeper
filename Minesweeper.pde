import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20 
public final static int NUM_ROWS = 11; public final static int NUM_COLS = 11; public final static int NUM_BOMBS = 2;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public boolean gameOver = false;
public int flagCount;
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS;r++) {
      for(int c = 0; c < NUM_ROWS;c++)
        buttons[r][c] = new MSButton(r,c);
    }
    
    setMines();
}
public void setMines()
{
  while(bombs.size() < NUM_BOMBS){
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if(bombs.contains(buttons[r][c]) == false){
      bombs.add(buttons[r][c]);
    }
  }
}

public void draw ()
{
    if(isWon() == true)
        flagCount = 0;
        displayWinningMessage();
  
}
public boolean isLose()
{
    for(int i = NUM_ROWS-1; i >= 0; i--){
      for(int q = NUM_COLS-1; q >= 0; q--){
        if(bombs.contains(buttons[i][q])){
          return true;
        }
      }
    }
      return false;
}
public boolean isWon()
{
    int winSum = 0;
    for(int i = NUM_ROWS-1; i >= 0; i--){
      for(int q = NUM_COLS-1; q >= 0; q--){
        if(buttons[i][q].getClicked() && !bombs.contains(buttons[i][q]))
          winSum++;
      }
      if(winSum == NUM_ROWS * NUM_COLS - bombs.size()){
        return true;
      }
    }
      return false;
      
}
public void displayLosingMessage()
{
if(isLose() == true && mousePressed == true)
        buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("Y");
        buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("O");
        buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("U");
        buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel(" ");
        buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("L");
        buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("O");
        buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("S");
        buttons[NUM_ROWS/2][NUM_COLS/2 + 3].setLabel("E");
        noLoop();
        for(int i = 0; i < bombs.size(); i++)
          bombs.get(i).clicked = true;
}
public void displayWinningMessage()
{
     if(isWon() == true && mousePressed == true){
        buttons[NUM_ROWS/2][NUM_COLS/2 - 4].setLabel("Y");
        buttons[NUM_ROWS/2][NUM_COLS/2 - 3].setLabel("O");
        buttons[NUM_ROWS/2][NUM_COLS/2 - 2].setLabel("U");
        buttons[NUM_ROWS/2][NUM_COLS/2 - 1].setLabel(" ");
        buttons[NUM_ROWS/2][NUM_COLS/2].setLabel("W");
        buttons[NUM_ROWS/2][NUM_COLS/2 + 1].setLabel("I");
        buttons[NUM_ROWS/2][NUM_COLS/2 + 2].setLabel("N");
      noLoop();
    }
    
}
public boolean isValid(int r, int c)
{ 
    if(r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
}
public int countBombs(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row+1;r++){
      for(int c = col-1; c <= col+1;c++){
        if(isValid(r,c) && bombs.contains(buttons[r][c])){
          numMines++;
          }
        }
    }
    return numMines;
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col)
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = row;
        c = col; 
        x = r*width;
        y = c*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {   
 
      if(gameOver || isWon()) return;
        if(mouseButton == LEFT && myLabel.equals("") && !isFlagged()){
            clicked = true;
        }
        if(mouseButton == RIGHT && !getClicked()){
            flagged = !flagged;
            if(flagged)
                flagCount++;
            if(!flagged)
                flagCount--;
        }
        else if(bombs.contains(this) && !flagged){
            gameOver = true;
            displayLosingMessage();
            flagCount = 0;
        }
        else if(countBombs(r, c) > 0 && myLabel.equals("")){
            setLabel(myLabel + countBombs(r, c));
        }
        else{
            if(isValid(r,c-1) && myLabel.equals("") && buttons[r][c-1].getClicked() == false)
                buttons[r][c-1].mousePressed();
            if(isValid(r-1,c) && myLabel.equals("") && buttons[r-1][c].getClicked() == false)
                buttons[r-1][c].mousePressed();
            if(isValid(r,c+1) && myLabel.equals("") && buttons[r][c+1].getClicked() == false)
                buttons[r][c+1].mousePressed();
            if(isValid(r+1,c) && myLabel.equals("") && buttons[r+1][c].getClicked() == false)
                buttons[r+1][c].mousePressed();
        }
     } 
   public boolean getClicked() 
   {
     return clicked;
   }
    public void draw () 
    {    
        if (flagged)
            fill(0,255,255);
        else if(clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
