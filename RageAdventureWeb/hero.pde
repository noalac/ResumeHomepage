class Hero extends Player {

  float speedStep = 2.5;
  float speedHeight = 100;
  float jumpDuration = 15;
  float deadDuration = 25;
  float wonDuration = 30;

  // Hero constructor
  Hero(float x, float y) {
    super("Hero");
    setupStates();
    setPosition(x, y);
    handleKey(LEFT);
    handleKey(RIGHT);
    handleKey(' ');
    setForces(0, DOWN_FORCE);
    setAcceleration(0, ACCELERATION);
    setImpulseCoefficients(DAMPENING, DAMPENING);    
  }

  void setupStates() {
    // add standing state
    addState(new State("standing", "graphics/hero/standing-hero.gif"));

    // add walking state
    State walking = new State("walking", "graphics/hero/walking-hero.gif", 1, 2);
    walking.setAnimationSpeed(0.2);
    addState(walking);

    // add jumping state
    State jumping = new State("jumping", "graphics/hero/jumping-hero.gif");
    jumping.setDuration(jumpDuration);
    addState(jumping);

    // add dead state
    State dead = new State("dead", "graphics/hero/dead-hero.gif"); 
    dead.setDuration(deadDuration);
    addState(dead);
    SoundManager.load(dead, "audio/boos.mp3");

    // add dead state
    State won = new State("won", "graphics/hero/standing-hero.gif"); 
    won.setDuration(wonDuration);
    addState(won);
    SoundManager.load(won, "audio/congratulations.mp3");

    // set default state as standing
    setCurrentState("standing");
  }

  void overlapOccurredWith(Actor other, float[] direction) {
    if ((other instanceof Slime) || (other instanceof Missile)) { die(); }
    else if (other instanceof SpecialBlock) {
      // hit an information block
      ((SpecialBlock)other).reaction();
    } else if (other instanceof StaticEnemy) {
      ((StaticEnemy)other).dangerous(this);
    }
  }

  void die() {
    if (active.name!="dead") {
      // OK we dead
      setCurrentState("dead");
      // stop the background music
      SoundManager.stop(getLevelLayer().getLevel());
      // play dead music
      SoundManager.play(active);

      // lower IQ
      IQ -= 50;
    }
  }

  void win() {
    if (active.name != "won") {
      setCurrentState("won");
      SoundManager.play(active);

      // recover IQ
      IQ = 250;
    }
  }
  
  void handleStateFinished(State which) {
    if (which.name == "dead" || which.name == "won") {
      // dead, restart
      removeActor();
      reset();
    } else {
      // recover standing state
      setCurrentState("standing");
    }
  }

  void handleInput() {
    // check if our hero fall out of the screen, which means dead
    // "active obj is not dead" is important, or hero will die 3 times! 
    if (active.name=="dead" || active.name=="won") { return; }
    else if (getBoundingBox()[1] > screenHeight) { die(); }
    else {
        // we have to do it all by ourselves
        if (keyCode == LEFT) { isKeyDown[LEFT] = true; }
        else if (keyCode == RIGHT) { isKeyDown[RIGHT] = true; }
    }

    // handle walking
    if ( isKeyDown(LEFT) ) {
      setHorizontalFlip(true);
      addImpulse(-speedStep, 0);
      setViewDirection(-1,0);
    }
    if ( isKeyDown(RIGHT) ) {
      setHorizontalFlip(false);
      addImpulse(speedStep, 0);
      setViewDirection(1,0);
    }
 
    if (active.mayChange()) {
      if(isKeyDown(' ') && active.name!="jumping" && boundaries.size()>0) {

        // check if the boundary is a wall, not good enough, but works
        if ( (boundaries.size()!=1) ||
             (boundaries.get(0).minx != boundaries.get(0).maxx) ) {
          ignore(' ');
          detachFromAll();
          addImpulse(0, -speedHeight);
          setCurrentState("jumping");
        }
      }
      else if ( isKeyDown(LEFT) || isKeyDown(RIGHT) ) {
        setCurrentState("walking");
      } else {
        setCurrentState("standing");
      }
    }
  }
}
