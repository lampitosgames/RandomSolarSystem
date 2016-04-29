//  Daniel Timko
//  IGME 202-01
//  Rolling Through Random [HW 1]



//The solar system is the foundation of this sketch, holding all orbiting bodies and updating them during Draw()
System solarSystem;

//View Handler - The simulation technically runs on a massive screen.  This keeps/updates the variables that determine what portion of that larger screen should be displayed
ScreenspaceHandler screen;

//The draw scale of stars (independant of view scale)
float drawScale;
//The draw scale of planets & moons (independant of view scale)
float pDrawScale;

//The gravitational constant (different from real-world for the purposes of this sketch)
float gravConst;

//Background image.  It needs its own class in order to parallax properly
BackImage background;

//The ship (subject of this sketch)
Spaceship ship;

/**
 * The default setup method for processing
 */
void setup() {
  //Create the view handler
  screen = new ScreenspaceHandler(19730, 10800);
  
  //Set the screen size
  size(1600, 900);
  
  //Set the draw scale (Modify to quickly change how large/small everything is when drawing)
  drawScale = 400.0;
  pDrawScale = 6.0;
    
  //Create the background image object
  background = new BackImage();
  
  //Set the gravitational constant.  Higher means faster orbital velocity
  //In the real world, object masses are far higher and this value is 6.67E-11
  gravConst = 6.67E2;
  
  /*
    Generate the number of solar bodies this system has
  */
  //Create the solar system
  solarSystem = new System();
  //Add a random number of stars (1-3) to the system, weighted towards a binary system
  int randStars = int(random(100));
  //35% to be a default of 1
  int starCount = 1;
  //17% to be a 3 star system
  if (randStars < 17) {
    starCount = 3;
  //48% to be a binary system
  } else if (randStars < 57) {
    starCount = 2;
  }
  //Create a number of stars equal to the generated directed random value
  for (int i=0; i<starCount; i++) {
    solarSystem.AddStar();
  }
  
  /*
    Generate the number of planetary bodies this system has
  */
  //Same logic as star generation
  int randPlanets = int(random(100));
  int planetCount;
  //10% to be 4
  if (randPlanets < 10) {
    planetCount = 4;
  //30% to be 5
  } else if (randPlanets < 40) {
    planetCount = 5;
  //35% to be default of 6
  } else if (randPlanets < 75) {
    planetCount = 6;
  //20% to be 7
  } else if (randPlanets < 95) {
    planetCount = 7;
  //5% to be 8
  } else {
    planetCount = 8;
  }
  for (int j=0; j<planetCount; j++) {
    solarSystem.AddPlanet();
  }
  
  //Call PlaceStars() to calculate orbits and put stars in the proper locations
  solarSystem.PlaceStars();
  //Call PlacePlanets() to set up planetary orbits
  solarSystem.PlacePlanets();
  
  //Move the view to be centered on the stars
  screen.MoveView(screen.canvasWidth/2 - screen.viewWidth/2, screen.canvasHeight/2 - screen.viewHeight/2);
  
  //Create a spaceship
  ship = new Spaceship();
}

/**
 * The default draw method for processing
 */
void draw() {
  //Draw the background, clearing everything drawn last frame
  background(0);
  //Draw the image background
  background.Draw();
  
  //Update and draw the solar system and all stars, planets, orbits, and moons it contains
  solarSystem.Draw();
  
  //Draw the ship
  ship.Draw();
}

/**
 * Event listener for click-dragging the mouse
 */
void mouseDragged() {
  //Un-snap the view from the ship
  ship.viewSnap = false;
  
  //Move the view pixel-for-pixel with the mouse
  //View scale must be taken into account if objects are to move at the same speed as the mouse
  screen.MoveView(screen.viewX + (int)(pmouseX/screen.viewScale - mouseX/screen.viewScale), screen.viewY + (int)(pmouseY/screen.viewScale - mouseY/screen.viewScale));
}

/**
 * Event listener for mouse scroll
 */
void mouseWheel(MouseEvent event) {
  //Save the scroll direction
  float e = event.getCount();
  
  //Zoom in or out based on the scroll direction
  if (e > 0) {
    screen.ScaleView(screen.viewScale - 0.1);
  } else {
    screen.ScaleView(screen.viewScale + 0.1);
  }
}

/**
 * Event listener for a key release
 */
void keyReleased() {
  //If the spacebar was released
  if (key == 32) {
    //Snap the view to follow the ship
    ship.viewSnap = true;
  }
}