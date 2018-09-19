class Slime extends Interactor {
  float speed = 1.5;
  Slime(float x, float y) {
    super("Slime");
    setStates();
    setForces(-speed, DOWN_FORCE);
    setImpulseCoefficients(DAMPENING, DAMPENING);
    setPosition(x, y);
  }

  void setStates() {
    addState(new State("moving", "graphics/enemy/slime.gif", 1, 1));
  }

  void gotBlocked(Boundary b, float[] intersection, float[] original) {
    //  left turn && right turn
    if(b.x == b.xw || b.x == b.xw - 2) {
      fx = -fx;
      setHorizontalFlip(fx > 0);
    }
  }
}

class Missile extends Interactor {
  float initx, inity;
  Missile(float x, float y) {
    super("Missile");
    this.initx = x;
    this.inity = y;
    setStates();
    // fly to top!
    setForces(0, 0);
    setImpulseCoefficients(DAMPENING, DAMPENING);
    setPosition(x, y);
  }

  void setStates() {
    addState(new State("flying", "graphics/enemy/missile.gif", 1, 1));
  }
}

// StaticEnemy dont move, dangerous only when hero hit into them
class StaticEnemy extends Interactor {
  boolean harm = false;
  StaticEnemy(String picname, float x, float y, boolean h) {
    super("StaticEnemy");
    harm = h;
    setStates(picname);
    setForces(0, 0);
    setImpulseCoefficients(DAMPENING, DAMPENING);
    setPosition(x, y);
  }

  void setStates(String pic) {
    addState(new State("normal", "graphics/enemy/"+pic+".gif", 1, 1));
    addState(new State("bad", "graphics/enemy/bad"+pic+".gif", 1, 1));
    setCurrentState("normal");
  }

  void dangerous(Actor other) {
    if (harm) { 
      setCurrentState("bad");
      ((Hero)other).die();
    }
  }
}

