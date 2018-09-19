/**
 * override!
 * this disables the default "loop()" when using addScreen
 */
void addScreen(String name, Screen screen) {
  screenSet.put(name, screen);
  if (activeScreen == null) { activeScreen = screen; }
  else { SoundManager.stop(activeScreen); }
}

/* @pjs pauseOnBlur="true";
        font="fonts/acmesa.ttf";
        preload=" graphics/mute.gif,
                  graphics/unmute.gif,
                  graphics/hero/standing-hero.gif,
                  graphics/hero/walking-hero.gif,
                  graphics/hero/jumping-hero.gif,
                  graphics/hero/dead-hero.gif,
                  graphics/background/sky.gif,
                  graphics/background/ground.gif,
                  graphics/background/skyfar.gif,
                  graphics/item/lady.gif,
                  graphics/item/coin.gif,
                  graphics/item/block.gif,
                  graphics/item/unknown.gif,
                  graphics/item/go.gif,
                  graphics/item/hidden.gif,
                  graphics/item/brick.gif,
                  graphics/item/key.gif,
                  graphics/item/tube.gif,
                  graphics/enemy/saw.gif,
                  graphics/enemy/sawleft.gif,
                  graphics/enemy/sawright.gif,
                  graphics/enemy/cloud.gif,
                  graphics/enemy/badcloud.gif,
                  graphics/enemy/grass.gif,
                  graphics/enemy/badgrass.gif,
                  graphics/enemy/missile.gif,
                  graphics/enemy/slime.gif"; */
