class InfoTrigger extends Trigger {
  InfoTrigger(float x, float y, float w, float h) {
    super("InfoTrigger", x, y, w, h);
  }

  void run(LevelLayer layer, Actor actor, float[] intersection) {
    infoblock.setForces(0, DOWN_FORCE-1);
    infoblock.setImpulseCoefficients(DAMPENING, DAMPENING);
    infoblock.addImpulse(0, 20);
    removeTrigger();
  }
}

class MissileTrigger extends Trigger {
  MissileTrigger(float x, float y, float w, float h) {
    super("MissileTrigger", x, y, w, h);
  }

  void run(LevelLayer layer, Actor actor, float[] intersection) {
    missile.setPosition(missile.initx, missile.inity);
    missile.setForces(0, -DOWN_FORCE);
    missile.addImpulse(0, -20);
    // the trigger line keeps forever
  }
}


