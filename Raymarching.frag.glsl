#define NUM_OBJECTS 20
uniform float time;
uniform vec2 resolution;
uniform vec3 objectColor;
uniform vec3 backgroundColor;
uniform vec3 baseLightColor;
uniform vec3 spotLightColor;
uniform vec3 spot2LightColor;
uniform float deformationFrequency;
uniform float deformationAmount;
uniform vec3 camera;
uniform vec4 objects [NUM_OBJECTS];


////////////////////////////////////
// Settings ////////////////////////
////////////////////////////////////
#define STEPS 64
#define NORMAL_EPSILON 0.1
#define REFLECTION_EPSILON 0.1
////////////////////////////////////
// Constants ///////////////////////
////////////////////////////////////
#define BG_MAT 0.0
#define NORMAL_MAT 1.0
#define STEPS_MAT 2.0
#define CHROME_MAT 3.0
#define DIST_MAT 4.0
////////////////////////////////////
// Macros //////////////////////////
////////////////////////////////////
#define RETURN_SIMPLE_MATERIAL(c,i) Material m; m.id = i; m.base = c; m.reflAmt = 0.0; m.refrAmt = 0.0; return m;

#define DEF_MAT(x) Material x (in Result r)

#define DEF_MAT_POST(x) Material x (in Material m)

#define RESOLVE_MAT(r,m) if(r.mat == NORMAL_MAT) m = matNormal(r); else if(r.mat == STEPS_MAT) m = matSteps(r); else if(r.mat == CHROME_MAT) m = matChrome(r); else if(r.mat == DIST_MAT) m = matDist(r); else m = matBg(r);

#define RESOLVE_MAT_REFL(m,mm) if(m.id == CHROME_MAT) mm = matChromeRefl(mm);

#define RESOLVE_MAT_REFR(m,mm)

#define MARCH_REFLECTION(r) march(r.pos - r.dir * REFLECTION_EPSILON, normalize(reflect(r.dir, r.normal)));

#define BEGIN_REFL(m,mm) if(m.reflAmt > 0.0){ Material mm; RESOLVE_MAT(m.refl, mm)
#define END_REFL(m,mm) RESOLVE_MAT_REFL(m,mm) m.base = mix(m.base, mm.base, m.reflAmt);	}

#define BEGIN_REFR(m,mm) if(m.refrAmt > 0.0){ Material mm; RESOLVE_MAT(m.refr, mm)
#define END_REFR(m,mm) RESOLVE_MAT_REFR(m,mm) m.base = mix(m.base, mm.base, m.refrAmt); }

#define SPHERE(p,r,m) vec2(sphere(pos-p,r),m)

////////////////////////////////////
// Types ///////////////////////////
////////////////////////////////////
struct Result{
	bool hit;
	vec3 pos;
	vec3 dir;
	vec3 normal;
	float mat;
	float dist;
	float time;
	float steps;
};
struct Material{
	float id;
	vec3 base;
	float reflAmt;
	float refrAmt;
	Result refl;
	Result refr;
};
////////////////////////////////////
// Shapes //////////////////////////
////////////////////////////////////
float plane( vec3 p ){
	return p.y;
}
float sphere( vec3 p, float s ){
	return length(p)-s;
}
float box( vec3 p, vec3 b ){
	vec3 d = abs(p) - b;
	return min(max(d.x,max(d.y,d.z)),0.0) +
			length(max(d,0.0));
}
float roundedBox( vec3 p, vec3 b, float r ){
  return length(max(abs(p)-b,0.0))-r;
}
////////////////////////////////////
// Distance Operations /////////////
////////////////////////////////////
vec2 join(in vec2 d1, in vec2 d2){
	return (d1.x < d2.x) ? d1 : d2;
}
////////////////////////////////////
// Distance Function ///////////////
////////////////////////////////////
vec2 map(in vec3 pos){
	vec2 s1 = SPHERE(vec3(-1,-0.25,0), 0.1, DIST_MAT);
	vec2 s2 = SPHERE(vec3(0.1,0.1,0), 0.1, CHROME_MAT);
	return join(s1, s2);
}
////////////////////////////////////
// Calculations ////////////////////
////////////////////////////////////
vec3 calcNormal(in vec3 pos){
	const vec3 e = vec3(NORMAL_EPSILON, 0.0, 0.0);
	return normalize(vec3(
		map(pos+e.xyz).x - map(pos-e.xyz).x,
		map(pos+e.yxz).x - map(pos-e.yxz).x,
		map(pos+e.yzx).x - map(pos-e.yzx).x
	));
}
////////////////////////////////////
// Raymarch ////////////////////////
////////////////////////////////////
Result march(in vec3 pos, in vec3 dir){
	Result r;
	r.hit = false;
	r.mat = BG_MAT;

	r.dir = dir;
	r.time = 0.0;
	r.steps = 0.0;
	vec2 mapped;
	for(int i = 0; i < STEPS; i++){
		r.steps += 1.0;
		r.pos = pos + dir * r.time;
		mapped = map(r.pos);
		r.dist = mapped.x;
		if(r.dist < 0.01 || r.dist > 2.0) break;
		r.time += r.dist;
	}
	if(r.dist < 0.01){
		r.hit = true;
		r.normal = calcNormal(r.pos);
		r.mat = mapped.y;
	}
	return r;
}
////////////////////////////////////
// Materials ///////////////////////
///////////////////////////////////
DEF_MAT(matBg){
	float dd = dot(r.dir, vec3(0.0, 1.0, 0.0));
	vec3 c = vec3(sin(sin(dd)*30.0));
	RETURN_SIMPLE_MATERIAL(c, BG_MAT)
}
DEF_MAT(matNormal){
	vec3 c = r.normal;
	RETURN_SIMPLE_MATERIAL(c, NORMAL_MAT)
}
DEF_MAT(matSteps){
	vec3 c = vec3(r.steps / float(STEPS));
	RETURN_SIMPLE_MATERIAL(c, STEPS_MAT)
}
DEF_MAT(matDist){
	vec3 c = vec3(r.pos.z + 0.5);
	RETURN_SIMPLE_MATERIAL(c, DIST_MAT)
}
DEF_MAT(matChrome){
	Material m;
	m.id = CHROME_MAT;
	m.base = vec3(1.0);
	m.reflAmt = 1.0;
	m.refrAmt = 0.0;
	m.refl = MARCH_REFLECTION(r)
	return m;
}
DEF_MAT_POST(matChromeRefl){
	//m.base *= vec3(0.9,0.6,1.0);
	return m;
}
////////////////////////////////////
// Render //////////////////////////
////////////////////////////////////
vec3 render(in Result r){
	Material m;
	RESOLVE_MAT(r,m)

	BEGIN_REFL(m,ml)
		BEGIN_REFL(ml,mml)
		END_REFL(ml,mml)
		BEGIN_REFR(ml,mml)
		END_REFR(ml,mml)
	END_REFL(m,ml)

	BEGIN_REFR(m,mr)
		BEGIN_REFL(mr,mmr)
		END_REFL(mr,mmr)
		BEGIN_REFR(mr,mmr)
		END_REFR(mr,mmr)
	 END_REFR(m,mr)

	return m.base;
}
////////////////////////////////////
// Main ////////////////////////////
////////////////////////////////////
void main(){
	//vec2 uv = (gl_FragCoord.xy / resolution.xy ) ;
	//uv.x *= resolution.x / resolution.x;

	vec3 position = vec3(0.0, -2);
	vec3 direction = vec3(0,0,1.0);

	Result r = march(position, direction);

	vec3 color = render(r);


	gl_FragColor = vec4(color, 1.0);
}
