//Half-Edge or Doubly-Connected Edge Datastructure
//see Chapter 2 of Computational Geometry: Algorithms and Applications, especially p32
//Mark de Berg, Ottfried Cheong, Mark van Kreveld, Mark Overmars
//http://goo.gl/ecXcn

class HEM {
  //FACE ARRAY, SOME INCIDENT EDGE INDEX
  Face[] f;
  int[] fIE;
  Pt[] fN;
  Pt[] fC;
  Pt[] fH;

  //EDGE PTS OBJ, ORIGIN VERTEX, PREVIOUS EDGE, NEXT EDGE, TWIN EDGE, INCIDENT FACE INDICES
  //Obj e;
  Pts[] e;
  int [] eOV;
  //!!!!  fix ePE  !!!!!
  int [] ePE;
  int [] eNE;
  int [] eTE;  
  int [] eIF; 
  Pts[] eDraw;

  //  VERTEX COORDINATES, INCIDENT EDGE INDEX
  Pt[] v;
  int[] vIE;



  //CONSTRUCTOR (COORDINATE ARRAY[vertex index][x,y,z], FACE-VERTEX INDEX ARRAYLIST[face index](vertexindex) )
  HEM(float[][] coords, ArrayList[] ndx) {

    PVector zVec = new PVector(0, 0, 1); //not sure if this is the best place for this!!!
    //Also, you'll may want to re-write the fH part below as I couldn't figure it out strictly within anar...
    //...PtCross doesn't seem to be working

    //  CREATE VERTICES FIRST IN v[]
    v=new Pt[coords.length];
    vIE= new int[coords.length] ;
    for(int i=0; i<coords.length; i++) {
      v[i]=Anar.Pt(coords[i][0],coords[i][1],coords[i][2]);
    }

    //  CREATE FACES, EDGE ORIGIN ARRAYLIST, ADJ FACE ARRAYLIST
    f=new Face[ndx.length];
    fIE=new int[ndx.length];
    fN=new Pt[ndx.length];
    fC=new Pt[ndx.length];
    fH=new Pt[ndx.length];

    ArrayList eOriginVertex=new ArrayList();
    ArrayList eIncidentFace=new ArrayList();
    ArrayList ePrevEdge=new ArrayList();
    ArrayList eNextEdge=new ArrayList();

    Obj eTemp=new Obj();
    ArrayList eDrawTemp = new ArrayList();

    //  LOOP THROUGH TEXT FILE, NUMBER OF FACES
    for (int j=0; j<ndx.length; j++) {
      f[j]=new Face(); 
      //f[j].fill(20f,20f);
      //  LOOP THROUGH VERTICES FOR EACH FACE
      for (int m=0; m<ndx[j].size(); m++) {
        int mNdx= (Integer) ndx[j].get(m);
        int mPlus= (Integer) ndx[j].get((m+1) % ndx[j].size());
        //  CREATE FACE
        f[j].add( v[mNdx] );

        eTemp.add(new Pts(v[mNdx], v[mPlus]));
        //  ADD TO PREVIOUS EDGE INDEX ARRAYLIST (IF m!=0 THIS IS SIZE OF ARRAYLIST - BEFORE ADDING THIS EDGE)
        if (m!=0) {
          ePrevEdge.add( eOriginVertex.size()-1 );
        } 
        else { //WILL BE LAST IN THIS LOOP (IE SIZE OF ARRAYLIST + NUMBER OF EDGES)
          ePrevEdge.add( (eOriginVertex.size()-1) +  (ndx[j].size()-1) );
        }

        //  ADD VERTEX INDEX TO EDGE ORIGIN INDEX ARRAYLIST
        eOriginVertex.add( mNdx );
        //  CREATE INDEX FOR EACH VERTEX TO SOME EDGE veNdx[v#][0]=face#, veNdx[v#][1]=edge#
        vIE[mNdx]=eOriginVertex.size()-1;

        //  ADD TO NEXT EDGE INDEX ARRAYLIST (IF m!=LAST EDGE THIS IS SIZE OF ARRAYLIST - AFTER ADDING THIS EDGE)
        if ( m!=(ndx[j].size()-1) ) {
          eNextEdge.add(eOriginVertex.size() );
        } 
        else { //WILL BE FIRST IN LOOP (IE SIZE OF ARRAYLIST - NUMBER OF EDGES)
          eNextEdge.add( (eOriginVertex.size()) -  (ndx[j].size()) );
        }
        //ADD FIRST EDGE INDEX TO FACE EDGE ARRAY
        if (m==0) { 
          fIE[j]=eOriginVertex.size()-1;
        }

        //  ADD FACE INDEX TO EDGE ADJACENT FACE INDEX ARRAYLIST
        eIncidentFace.add(j);
      }
      //f[j].fill(25,35,50);
      f[j].fill(0,180);
      fN[j]=Anar.Pt(f[j].normal().x()- f[j].center().x(), f[j].normal().y()- f[j].center().y(), f[j].normal().z()- f[j].center().z() );
      fC[j]=f[j].center();
      //this could be better?!
      PVector fHvec = zVec.cross(new PVector(fN[j].x(), fN[j].y(), fN[j].z()));
      fH[j]=Anar.Pt(fHvec.x, fHvec.y, fHvec.z);
    }  

    //CONVERT TO ARRAYS FOR EASIER RECALL
    eOV=new int[eOriginVertex.size()];  
    ePE=new int[ePrevEdge.size()];
    eNE=new int[eNextEdge.size()];
    eIF=new int[eIncidentFace.size()];
    e=new Pts[eTemp.numOfLines()];

    for (int i=0; i<eOriginVertex.size(); i++) {
      eOV[i]=(Integer) eOriginVertex.get(i);
      ePE[i]=(Integer) ePrevEdge.get(i);
      eNE[i]=(Integer) eNextEdge.get(i);
      eIF[i]=(Integer) eIncidentFace.get(i);
      e[i]=eTemp.getLine(i);
    }

    //FILL eTE ARRAY FOR EDGES WITHOUT TWINS
    eTE = new int[eOV.length]; 
    for (int i=0; i<eTE.length; i++) {
      eTE[i]=-10;
    }
    //FILL eTE ARRAY FOR EDGES WITH TWINS
    for (int a=0; a<eOV.length; a++) {
      int aSt = eOV[a];
      int aNxt= eNE[a];
      int aEn = eOV[aNxt];

      for (int b=0; b<eOV.length; b++) {
        if (a!=b) {
          int bSt = eOV[b];
          int bNxt= eNE[b];
          int bEn = eOV[bNxt];

          if (aSt==bEn && aEn==bSt) {
            eTE[a]=(b); 
            if (b>a) { 
             eDrawTemp.add( a);
            }
            break;
          }
        }
      }
    }
    eDraw=new Pts[eDrawTemp.size()];
    for (int i=0; i<eDrawTemp.size(); i++){
      int nx= (Integer) eDrawTemp.get(i);
      eDraw[i]=e[nx];
    }
  }



  void splitCntr(int n) {
    //println("F:"+n+" IE: "+ fIE[n]+","+ eNE[fIE[n]]+","+eNE[eNE[fIE[n]]]);
    int vCt = v.length;
    int eCt = e.length;
    //int eCt = e.numOfLines();
    int fCt = f.length;
    int x=eNE[fIE[n]];

    //  ADD CENTROID TO V
    v =(Pt[]) append( v,  f[n].center());

    //  MAKE FIRST FACE
    int n0=eOV[fIE[n]];
    int n1=eOV[eNE[fIE[n]]];
    f[n]=new Face( v[n0], v[n1], v[vCt]);
    //  NEW NEXT-EDGE WILL BE NEXT ONE ADDED (EDGE1)
    eNE[fIE[n]]=eCt;
    //  CURRENT INCIDENT EDGE, TWIN EDGE, FACE INCIDENT EDGE STAY SAME

    //  ADD EDGE1
    e = (Pts[]) append (e, new Pts(v[n1], v[vCt]));
    eOV = append (eOV, n1);
    //  NEW NEXT-EDGE IS (EDGE2), PREVIOUS EDGE IS (EXISTING)
    eNE = append (eNE, eCt+1); 
    ePE = append (ePE, fIE[n]);
    //  NEW TWIN EDGE
    eTE =  append (eTE, eCt+3);
    //  ADD INCIDENT FACE
    eIF = append(eIF, n);


    //  ADD EDGE2
    //e.add(new Pts(v[vCt], v[n0]));
    e = (Pts[]) append (e, new Pts(v[vCt], v[n0]));
    eOV = append (eOV, vCt);
    //  NEW NEXT-EDGE IS (EXISTING), PREVIOUS EDGE IS (EDGE1)
    eNE = append (eNE, fIE[n]);  
    ePE = append (ePE, eCt);
    //  NEW TWIN EDGE
    eTE =  append (eTE, -10);
    //  ADD INCIDENT FACE
    eIF = append(eIF, n);

    //  CENTROID INCIDENT EDGE
    vIE = append(vIE, eCt+1);  


    int eCtx= eCt+2;
    int xTmp;
    //  LOOP THROUGH OTHER EDGES
    while(x != fIE[n]) {

      //  ADD NEXT FACES
      int x0=eOV[x];
      int x1=eOV[eNE[x]];
      f=(Face[])append(f, new Face( v[x0], v[x1], v[vCt] ));
      //  SET INCIDENT EDGE TO EXISTING EDGE AND V.V.
      fIE=append(fIE, x);
      eIF[x]=fCt;
      //  NEW NEXT-EDGE WILL BE NEXT ONE ADDED (EDGE1)
      xTmp=eNE[x];
      eNE[x]=eCtx;
      //  ADD EDGE1
      e = (Pts[]) append (e, new Pts( v[x1], v[vCt] ));
      eOV = append (eOV, x1 );
      //  NEW NEXT EDGE IS (EDGE2), PREVIOUS EDGE IS (EXISTING)
      eNE = append (eNE, eCtx+1);  
      ePE = append (ePE,x);
      //  NEW TWIN EDGE
      eTE =  append (eTE, eCtx+3);
      //  ADD INCIDENT FACE
      eIF = append(eIF, fCt);


      //  ADD EDGE2
      e = (Pts[]) append (e, new Pts( v[x1], v[vCt] ));
      eOV = append (eOV, vCt );
      //  NEW NEXT EDGE IS (EXISTING), PREVIOUS EDGE IS (EDGE1)
      eNE = append (eNE, x);  
      ePE = append (ePE, eCtx);
      //  NEW TWIN EDGE
      eTE =  append (eTE, eCtx-2);
      //  ADD INCIDENT FACE
      eIF = append(eIF, fCt);
      // 


      x=xTmp;  //eNE[x];


      eCtx+=2;
      fCt+=1;
    }
    eTE[eCtx-2]=eCt+1;
    eTE[eCt+1]=eCtx-2;
    //println("F:"+n+" IE: "+ fIE[n]+","+ eNE[fIE[n]]+","+eNE[eNE[fIE[n]]]);
    //v[vCt].translateZ(500);
  }



  void displayF() {
    for (int i=0; i<f.length; i++) {
      f[i].draw();
    }
  }

  void displayV() {
    for (int i=0; i<v.length; i++) {
      v[i].draw();
    }
  }

  void displayE() {
    for (int i=0; i<eDraw.length; i++) {
      eDraw[i].stroke(200,50);

      /*/  SHADE/WEIGHT EDGES BY SLOPE
       float deltZ=  abs(e[i].getPt(0).z()-e[i].getPt(1).z());
       float ang= asin(deltZ / e[i].length() );
       
       meshInit.e[i].stroke(250);
       if (ang<radians(30)) {e[i].stroke(220);}
       if (ang<radians(15)) {e[i].stroke(150); strokeWeight(2);}
       if (ang<radians(5)) {e[i].stroke(0); strokeWeight(3);}
       */

      eDraw[i].draw();
      strokeWeight(1);
    }
  }
}

