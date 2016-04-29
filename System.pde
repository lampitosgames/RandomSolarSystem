/**
 * The System Class
 * 
 * System holds all data for the solar system, updates and tracks all bodies within it, and calculates lots of physics
 */
class System {
  //A list of star objects
  ArrayList<Star> starList;
  //A list of planet objects
  ArrayList<Planet> planetList;
  //A list of the orbits in this system
  ArrayList<Orbit> orbitList;
  
  //The center of this system.  Defaults to the center of the canvas, and is later changed to the center of gravity
  int centerX, centerY;
  
  //Radius of circle to spawn stars on (explained later)
  float starSpawnRadius;
  
  //Total mass of this system
  float systemMass;
  
  //Direction of star orbits.  Planets have independant orbital directions
  int orbitDir;
  
  /**
   * Constructor
   */
  System() {
    //Set defaults
    starList = new ArrayList<Star>();
    planetList = new ArrayList<Planet>();
    orbitList = new ArrayList<Orbit>();
    centerX = screen.canvasWidth/2;
    centerY = screen.canvasHeight/2;
    systemMass = 0;
  }
  
  /**
   * Default Draw Method
   * 
   * Draw stars, orbits, planets, etc.
   */
  void Draw() {
     //Update all orbits (calculates new positions for stellar and planetary objects)
     for (int j=0; j<this.orbitList.size(); j++) {
       Orbit thisOrbit = this.orbitList.get(j);
       thisOrbit.Update();
       //Draw orbit lines
       stroke(255, 255, 255, 75);
       noFill();
       ellipseMode(RADIUS);
       ellipse((float)(thisOrbit.centerX*screen.viewScale-screen.viewX*screen.viewScale),
               (float)(thisOrbit.centerY*screen.viewScale-screen.viewY*screen.viewScale),
               (float)(thisOrbit.radius*screen.viewScale),
               (float)(thisOrbit.radius*screen.viewScale));
     }
     
     //Draw all stars in the star list
     for (int i=0; i<this.starList.size(); i++) {
        this.starList.get(i).Draw();
     }
     
     //Draw all planets in the planet list
     for (int p=0; p<this.planetList.size(); p++) {
        this.planetList.get(p).Draw();
     }
  }
  
  /**
   * Places stars semi-randomly in space, calculates a center of mass, and sets up star orbits and orbital velocity
   */
  void PlaceStars() {
    //Find the two largest (radius) stars
    float r1 = 0;
    float r2 = 0;
    for (int i=0; i<starList.size(); i++) {
       //Get this star's radius shifted for the draw scale
       float curRadius = starList.get(i).solarRadius*drawScale;
       //If the star's radius is larger than any other
       if (curRadius > r1) {
         //Move the current record holder to second place
         r2 = r1;
         //Set the new largest radius
         r1 = curRadius;
       }
    }
    
    //Calculate the theta based on the number of stars to place.
    /*
      We want to give each star it's own subsection of a placement circle (padded slightly).  This gives us
      the size of an arc that fits into a circle n times where n is the number of stars
    */
    float theta = 360/starList.size();
    
    //Get the placement radius (I did pen-and-paper trig to get this formula)
    //The reasoning behind this  is to fit the two largest stars at the edge of their possible placement 
    //zones. How far apart do they need to be so they won't touch?
    float R = (1.5*r1+1.5*r2)/sin(theta/4);
    
    //Spawn all the stars in their respective arcs along a 'placement circle', using random gaussian numbers so they tend toward the center of the arc
    for (int j=0; j<starList.size(); j++) {
      //Possible range is the middle half of the arc
      float angleMin = j*theta+(theta/4);
      float angleMax = j*theta+3*(theta/4);
      //Map the gaussian number to fit the arc range and get a placement value
      float angle = map(randomGaussian(), -4, 4, angleMin, angleMax);
      
      //Set the star's X and Y coordinates using trig
      starList.get(j).xPos = this.centerX + int(sin(radians(angle))*R);
      starList.get(j).yPos = this.centerY + int(cos(radians(angle))*R);
    }
    
    //Calculate the center of mass for the system
    /*
        x = (m1*x1)+(m2*x2)+...+(mn*xn)
            ___________________________
                   m1+m2+...+mn
                   
        y = (m1*y1)+(m2*y2)+...+(mn*yn)
            ___________________________
                   m1+m2+...+mn
    */
    float xNumerator = 0;
    float yNumerator = 0;
    
    //Determine the system mass.  Planets will never factor into this, that would get far too complex for the scope
    //Also in the loop, get the x and y numerator values for the equation (see above)
    for (int s=0; s<starList.size(); s++) {
       this.systemMass += starList.get(s).mass;
       
       xNumerator += starList.get(s).mass * starList.get(s).xPos;
       yNumerator += starList.get(s).mass * starList.get(s).yPos;
    }
    
    //Set the center of mass for the system.
    centerX = int(xNumerator/this.systemMass);
    centerY = int(yNumerator/this.systemMass);
    
    /*
      Calculate star orbital speed.  This speed is in degrees/second (normally meters/second.  1 degree = 1 meter on our scale.  The numbers here are obviously not accurate to science)
      Because of this, we don't need to worry about individual star calculations, all will move at the same angular speed, but faster or slower depending on their distance from the center of mass.
    */
    //Which direction does this system orbit?
    float orbitDirRandom= random(-5, 5);
    if (orbitDirRandom >= 0) {
      orbitDir = 1;
    } else {
      orbitDir = -1;
    }
    
    //Distance to object
    Star defaultStar = this.starList.get(0);
    float distToObject = sqrt(pow(defaultStar.xPos - this.centerX, 2) + pow(defaultStar.yPos - this.centerY, 2));
    //Star velocity (deg/sec).  Adjusted when the gravitational constant is adjusted
    float starSpeed = sqrt((gravConst*(this.systemMass+defaultStar.mass))/(distToObject)) * orbitDir;
    
    /*
      Create orbits for all stars
    */
    for (int q=0; q<starList.size(); q++) {
      this.orbitList.add(new Orbit(this.starList.get(q), orbitDir, this.systemMass, this.centerX, this.centerY));
      this.orbitList.get(q).speed = starSpeed;
    }
    
    //Save the placement radius + R1 + R2 to be used by planet spawning
    starSpawnRadius = R + r1 + r2;
  }
  
  /**
   * Place Planets semi-randomly
   */
  void PlacePlanets() {
    int baseRadius = (int)starSpawnRadius*2;
    //If there are more than 2 stars, increase the base radius and invert it (it will always be negative
    if (this.starList.size() > 2) {
      baseRadius *= -4;
    }
    
    int planetBeltSize = 7000/this.planetList.size();
    //Loop through every planet in the list
    for (int i=0; i<this.planetList.size(); i++) {
      //Get a random angle for this planet to start at
      float randTheta = random(361);
      
      //Which direction does this planet orbit?
      float planetDirRandom= random(-5, 5);
      int planetDir;
      if (planetDirRandom >= 0) {
        planetDir = 1;
      } else {
        planetDir = -1;
      }
      
      //Get a random radius for this planet and place it in the proper location
      float radiusMin = baseRadius + i*planetBeltSize;
      float radiusMax = baseRadius + i*(planetBeltSize+1);
      float planetOrbitDist = map(randomGaussian(), -4, 4, radiusMin, radiusMax);

      //Set the X and Y of the planet
      this.planetList.get(i).xPos = int(this.centerX + cos(radians(randTheta))*planetOrbitDist);
      this.planetList.get(i).yPos = int(this.centerY + sin(radians(randTheta))*planetOrbitDist);
      
      this.orbitList.add(new Orbit(this.planetList.get(i), planetDir, this.systemMass, this.centerX, this.centerY));
    }
  }
  
  /**
   * Add a single, random star to the system
   */
  void AddStar() {
    //This function gets the star type based on real-world data.  Some values are changed so as to not break the game.  The actual range of star size could either fill the screen, or only 1 pixel.
    //Use directed randomness to determine which star to create based on observed values
    int starTypeProb = int(random(100));
    //Get this star's gaussian value, clamp to be within the -4 to 4 range (very low possibility that it could fall outside of that, breaking the program)
    //Each star has a range of what it's radius/mass can be.  We're going to use the same gaussian value for each so that the scale is correct
    float gaussian = min(max(-4.0, randomGaussian()), 4);
    
    //Star object to be created
    Star thisStar;
    //Star parameters
    float starRadius, starMass;
    
    /*
      This next bit of code will create different stars based on the weighted random value for star type.
      I modeled this after some of the most common stars, albeit with slightly altered values.  I think 
      simulating hardcore science is awesome, but things like neutron stars are out of the scope of this project
    */
    //1.0% chance to be an O-Type Blue Supergiant || 16.0-20.0 solar masses || 2.9-3.7 solar radii *Not real world, real world is too large
    if (starTypeProb < 1) {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 2.9, 3.7);
      starMass = map(gaussian, -4.0, 4.0, 16.0, 20.0);
      //Create a Blue Supergiant
      thisStar = new Star(starMass, starRadius, 223, 69, 90);
      
    //5.0% chance to be a B-Type Blue Giant || 2.1-16.0 solar masses || 1.8-2.9 solar radii *Not real world, real world is too large
    } else if (starTypeProb < 6) {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 1.8, 2.9);
      starMass = map(gaussian, -4.0, 4.0, 2.1, 16.0);
      //Create a Blue Giant
      thisStar = new Star(starMass, starRadius, 198, 12, 89);
      
    //9.0% chance to be an A-Type white star || 1.4-2.1 solar masses || 1.4-1.6 solar radii
    } else if (starTypeProb < 15) {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 1.4, 1.6);
      starMass = map(gaussian, -4.0, 4.0, 1.4, 2.1);
      //Create a White Star
      thisStar = new Star(starMass, starRadius, 0, 0, 86);
      
    //15.0% chance to be an F-Type white star || 1.04-1.4 solar masses || 1.15-1.4 solar radii
    } else if (starTypeProb < 30) {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 1.15, 1.4);
      starMass = map(gaussian, -4.0, 4.0, 1.04, 1.4);
      //Create a Cream-Colored Star
      thisStar = new Star(starMass, starRadius, 48, 32, 95);
      
    //20.0% chance to be a G-Type yellow star || 0.8-1.04 solar masses || 0.96-1.15 solar radii (This is what our sun is)
    } else if (starTypeProb < 50) {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 0.96, 1.15);
      starMass = map(gaussian, -4.0, 4.0, 0.8, 1.04);
      //Create a Yellow Star
      thisStar = new Star(starMass, starRadius, 36, 48, 90);
      
    //25.0% chance to be a K-Type orange star || 0.45-0.8 solar masses || 0.7-0.96 solar radii
    } else if (starTypeProb < 75) {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 0.7, 0.96);
      starMass = map(gaussian, -4.0, 4.0, 0.45, 0.8);
      //Create an Orange Star
      thisStar = new Star(starMass, starRadius, 28, 69, 94);
      
    //25.0% chance to be a M-Type red dwarf || 0.2-0.45 solar masses || 0.4-0.7 solar radii 
    } else {
      //Map the gaussian number to fit the range of the mass and radius of this star class
      starRadius = map(gaussian, -4.0, 4.0, 0.4, 0.7);
      starMass = map(gaussian, -4.0, 4.0, 0.2, 0.45);
      //Create a Red Star
      thisStar = new Star(starMass, starRadius, 5, 69, 68);
    }
    
    //Add the newly created star to the star list
    starList.add(thisStar);
  }
  
  /**
   * Adds a single, random planet to the system.
   */
  void AddPlanet() {
    //Select a random planetary mass.
    float mass = random(0.2, 5.0);
    //Create a planet and add it to the planet list
    this.planetList.add(new Planet(mass));
  }
}