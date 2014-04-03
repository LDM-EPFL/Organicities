//void track(MomentumPt agent) {
//  if(frameCount < trackCt) {
//    String m = Float.toString(agent.mass);
//    String mSpd = Float.toString(agent.maxSpeed);
//    String mFrc = Float.toString(agent.maxForce);
//    String posX = Float.toString(agent.pos.x);
//    String posY = Float.toString(agent.pos.y);
//    String posZ = Float.toString(agent.pos.z);
//    String velX = Float.toString(agent.vel.x);
//    String velY = Float.toString(agent.vel.y);
//    String velZ = Float.toString(agent.vel.z);
//    String targetX = Float.toString(agent.target.x());
//    String targetY = Float.toString(agent.target.y());
//    String targetZ = Float.toString(agent.target.z());
//    String sepW = Float.toString(sepWt.get());
//    String sepX = Float.toString(agent.trSep.x);
//    String sepY = Float.toString(agent.trSep.y);
//    String sepZ = Float.toString(agent.trSep.z);
//    String aliW = Float.toString(aliWt.get());
//    String aliX = Float.toString(agent.trAli.x);
//    String aliY = Float.toString(agent.trAli.y);
//    String aliZ = Float.toString(agent.trAli.z);
//    String cohW = Float.toString(cohWt.get());
//    String cohX = Float.toString(agent.trCoh.x);
//    String cohY = Float.toString(agent.trCoh.y);
//    String cohZ = Float.toString(agent.trCoh.z);
//    String tarW = Float.toString(tarWt.get());
//    String tarX = Float.toString(agent.trTar.x);
//    String tarY = Float.toString(agent.trTar.y);
//    String tarZ = Float.toString(agent.trTar.z);
//    track[frameCount] = frameCount + " " + agent.id + " " + m + " " + mSpd + " " + mFrc + " " +
//      posX + " " + posY + " " + posZ + " " + 
//      velX + " " + velY + " " + velZ + " " + 
//      targetX + " " + targetY + " " + targetZ + " " +
//      sepW + " " + sepX + " " + sepY + " " + sepZ + " " +
//      aliW + " " + aliX + " " + aliY + " " + aliZ + " " +
//      cohW + " " + cohX + " " + cohY + " " + cohZ + " " +
//      tarW + " " + tarX + " " + tarY + " " + tarZ ;
//    saveStrings("track.txt", track);
//  }
//  else {
//    println("done");
//  }
//}

