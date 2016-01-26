uniform highp vec2 resolution;
uniform highp vec3 objectColor;
uniform highp vec3 backgroundColor;
uniform highp vec3 baseLightColor;
uniform highp vec3 spotLightColor;
uniform highp vec3 spot2LightColor;
uniform highp float blobStickiness;
uniform highp vec3 gradientTopColor;
uniform highp vec3 gradientBottomColor;
uniform highp float deformationFrequency;
uniform highp float deformationAmount;
uniform highp float halftoneGridSize;
uniform highp float halftoneSeparation;
uniform highp float halftonePrePower;
uniform highp float halftonePostPower;
uniform highp float halftoneMultiplier;
uniform highp float zoom;
uniform highp vec3 camera;
uniform vec4 objects[20];
void main ()
{
  highp vec3 halftoneColor_1;
  highp vec3 color_2;
  highp vec2 modBase_3;
  highp vec2 base_4;
  highp vec2 offset45deg_5;
  highp vec2 uv_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (((gl_FragCoord.xy / resolution) * 2.0) - 1.0);
  uv_6.y = tmpvar_7.y;
  uv_6.x = (tmpvar_7.x * (resolution.x / resolution.y));
  offset45deg_5 = vec2(0.0, 0.0);
  highp float tmpvar_8;
  tmpvar_8 = (float(mod (floor((tmpvar_7.y * halftoneGridSize)), 2.0)));
  if ((tmpvar_8 == 0.0)) {
    offset45deg_5 = vec2(0.5, 0.0);
  };
  highp vec2 tmpvar_9;
  tmpvar_9 = (uv_6 * halftoneGridSize);
  base_4 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10 = (vec2(mod (tmpvar_9, 1.0)));
  modBase_3 = tmpvar_10;
  if ((tmpvar_10.x > offset45deg_5.x)) {
    modBase_3 = (tmpvar_10 - offset45deg_5);
  } else {
    modBase_3 = (modBase_3 + offset45deg_5);
  };
  base_4 = (tmpvar_9 - modBase_3);
  highp vec2 tmpvar_11;
  tmpvar_11 = ((base_4 / halftoneGridSize) + ((
    (vec2(-0.08, -0.05) * halftoneSeparation)
   + offset45deg_5) / halftoneGridSize));
  highp vec2 x_12;
  highp float tmpvar_13;
  tmpvar_13 = (0.5 / halftoneGridSize);
  x_12 = ((uv_6 - (tmpvar_11 + tmpvar_13)) + (offset45deg_5 / halftoneGridSize));
  highp vec2 x_14;
  x_14 = ((uv_6 - (
    ((base_4 / halftoneGridSize) + (((vec2(0.0, 0.08) * halftoneSeparation) + offset45deg_5) / halftoneGridSize))
   + tmpvar_13)) + (offset45deg_5 / halftoneGridSize));
  highp vec2 x_15;
  x_15 = ((uv_6 - (
    ((base_4 / halftoneGridSize) + (((vec2(0.08, -0.05) * halftoneSeparation) + offset45deg_5) / halftoneGridSize))
   + tmpvar_13)) + (offset45deg_5 / halftoneGridSize));
  highp vec3 tmpvar_16;
  tmpvar_16.x = (sqrt(dot (x_12, x_12)) * halftoneGridSize);
  tmpvar_16.y = (sqrt(dot (x_14, x_14)) * halftoneGridSize);
  tmpvar_16.z = (sqrt(dot (x_15, x_15)) * halftoneGridSize);
  uv_6 = tmpvar_11;
  highp vec3 tmpvar_17;
  tmpvar_17.xy = tmpvar_11;
  tmpvar_17.z = zoom;
  bool tmpvar_18;
  highp vec3 tmpvar_19;
  highp vec3 point_20;
  tmpvar_18 = bool(0);
  highp vec3 tmpvar_21;
  tmpvar_21 = ((vec3(-7.0, -7.0, -10.0) - camera) / tmpvar_17);
  highp vec3 tmpvar_22;
  tmpvar_22 = ((vec3(7.0, 7.0, 2.0) - camera) / tmpvar_17);
  highp vec3 tmpvar_23;
  tmpvar_23 = max (tmpvar_22, tmpvar_21);
  highp vec3 tmpvar_24;
  tmpvar_24 = min (tmpvar_22, tmpvar_21);
  highp float tmpvar_25;
  tmpvar_25 = min (tmpvar_23.x, min (tmpvar_23.y, tmpvar_23.z));
  highp float tmpvar_26;
  tmpvar_26 = max (max (tmpvar_24.x, 0.0), max (tmpvar_24.y, tmpvar_24.z));
  if ((tmpvar_25 > tmpvar_26)) {
    highp vec3 tmpvar_27;
    tmpvar_27 = tmpvar_17;
    highp float val_28;
    bool tmpvar_29;
    bool tmpvar_30;
    tmpvar_30 = bool(0);
    highp float left_32;
    highp vec3 point_33;
    highp float time_34;
    highp float step_35;
    step_35 = ((tmpvar_25 - tmpvar_26) / 15.0);
    time_34 = tmpvar_26;
    highp vec3 tmpvar_36;
    tmpvar_36 = (camera + (tmpvar_26 * tmpvar_17));
    point_33 = tmpvar_36;
    highp vec3 point_37;
    point_37 = tmpvar_36;
    highp float distance_39;
    distance_39 = 0.0;
    for (highp int i_38 = 0; i_38 < 20; i_38++) {
      highp vec3 tmpvar_40;
      tmpvar_40 = (point_37 - objects[i_38].xyz);
      distance_39 = (distance_39 + (objects[i_38].w / (
        ((tmpvar_40.x * tmpvar_40.x) + (tmpvar_40.y * tmpvar_40.y))
       +
        (tmpvar_40.z * tmpvar_40.z)
      )));
    };
    distance_39 = (blobStickiness - distance_39);
    highp float tmpvar_41;
    tmpvar_41 = (((
      (sin((deformationFrequency * tmpvar_36.x)) * deformationAmount)
     *
      (sin((deformationFrequency * tmpvar_36.y)) * deformationAmount)
    ) * (
      sin((deformationFrequency * tmpvar_36.z))
     * deformationAmount)) + distance_39);
    distance_39 = tmpvar_41;
    left_32 = tmpvar_41;
    for (int i_31 = 0; i_31 < 15; i_31++) {
      point_33 = (point_33 + (step_35 * tmpvar_27));
      highp vec3 point_42;
      point_42 = point_33;
      highp float distance_44;
      distance_44 = 0.0;
      for (highp int i_43 = 0; i_43 < 20; i_43++) {
        highp vec3 tmpvar_45;
        tmpvar_45 = (point_42 - objects[i_43].xyz);
        distance_44 = (distance_44 + (objects[i_43].w / (
          ((tmpvar_45.x * tmpvar_45.x) + (tmpvar_45.y * tmpvar_45.y))
         +
          (tmpvar_45.z * tmpvar_45.z)
        )));
      };
      distance_44 = (blobStickiness - distance_44);
      highp float tmpvar_46;
      tmpvar_46 = (((
        (sin((deformationFrequency * point_33.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_33.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_33.z))
       * deformationAmount)) + distance_44);
      distance_44 = tmpvar_46;
      if (((left_32 * tmpvar_46) < 0.0)) {
        val_28 = (time_34 + ((tmpvar_46 * step_35) / (left_32 - tmpvar_46)));
        tmpvar_29 = bool(1);
        tmpvar_30 = bool(1);
        break;
      };
      left_32 = tmpvar_46;
      time_34 = (time_34 + step_35);
    };
    if (!(tmpvar_30)) {
      tmpvar_29 = bool(0);
      tmpvar_30 = bool(1);
    };
    if (tmpvar_29) {
      point_20 = (camera + (tmpvar_17 * val_28));
      highp vec3 point_47;
      point_47 = (point_20 + vec3(0.001, 0.0, 0.0));
      highp float distance_49;
      distance_49 = 0.0;
      for (highp int i_48 = 0; i_48 < 20; i_48++) {
        highp vec3 tmpvar_50;
        tmpvar_50 = (point_47 - objects[i_48].xyz);
        distance_49 = (distance_49 + (objects[i_48].w / (
          ((tmpvar_50.x * tmpvar_50.x) + (tmpvar_50.y * tmpvar_50.y))
         +
          (tmpvar_50.z * tmpvar_50.z)
        )));
      };
      distance_49 = (blobStickiness - distance_49);
      highp float tmpvar_51;
      tmpvar_51 = (((
        (sin((deformationFrequency * point_47.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_47.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_47.z))
       * deformationAmount)) + distance_49);
      distance_49 = tmpvar_51;
      highp vec3 point_52;
      point_52 = (point_20 - vec3(0.001, 0.0, 0.0));
      highp float distance_54;
      distance_54 = 0.0;
      for (highp int i_53 = 0; i_53 < 20; i_53++) {
        highp vec3 tmpvar_55;
        tmpvar_55 = (point_52 - objects[i_53].xyz);
        distance_54 = (distance_54 + (objects[i_53].w / (
          ((tmpvar_55.x * tmpvar_55.x) + (tmpvar_55.y * tmpvar_55.y))
         +
          (tmpvar_55.z * tmpvar_55.z)
        )));
      };
      distance_54 = (blobStickiness - distance_54);
      highp float tmpvar_56;
      tmpvar_56 = (((
        (sin((deformationFrequency * point_52.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_52.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_52.z))
       * deformationAmount)) + distance_54);
      distance_54 = tmpvar_56;
      highp vec3 point_57;
      point_57 = (point_20 + vec3(0.0, 0.001, 0.0));
      highp float distance_59;
      distance_59 = 0.0;
      for (highp int i_58 = 0; i_58 < 20; i_58++) {
        highp vec3 tmpvar_60;
        tmpvar_60 = (point_57 - objects[i_58].xyz);
        distance_59 = (distance_59 + (objects[i_58].w / (
          ((tmpvar_60.x * tmpvar_60.x) + (tmpvar_60.y * tmpvar_60.y))
         +
          (tmpvar_60.z * tmpvar_60.z)
        )));
      };
      distance_59 = (blobStickiness - distance_59);
      highp float tmpvar_61;
      tmpvar_61 = (((
        (sin((deformationFrequency * point_57.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_57.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_57.z))
       * deformationAmount)) + distance_59);
      distance_59 = tmpvar_61;
      highp vec3 point_62;
      point_62 = (point_20 - vec3(0.0, 0.001, 0.0));
      highp float distance_64;
      distance_64 = 0.0;
      for (highp int i_63 = 0; i_63 < 20; i_63++) {
        highp vec3 tmpvar_65;
        tmpvar_65 = (point_62 - objects[i_63].xyz);
        distance_64 = (distance_64 + (objects[i_63].w / (
          ((tmpvar_65.x * tmpvar_65.x) + (tmpvar_65.y * tmpvar_65.y))
         +
          (tmpvar_65.z * tmpvar_65.z)
        )));
      };
      distance_64 = (blobStickiness - distance_64);
      highp float tmpvar_66;
      tmpvar_66 = (((
        (sin((deformationFrequency * point_62.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_62.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_62.z))
       * deformationAmount)) + distance_64);
      distance_64 = tmpvar_66;
      highp vec3 point_67;
      point_67 = (point_20 + vec3(0.0, 0.0, 0.001));
      highp float distance_69;
      distance_69 = 0.0;
      for (highp int i_68 = 0; i_68 < 20; i_68++) {
        highp vec3 tmpvar_70;
        tmpvar_70 = (point_67 - objects[i_68].xyz);
        distance_69 = (distance_69 + (objects[i_68].w / (
          ((tmpvar_70.x * tmpvar_70.x) + (tmpvar_70.y * tmpvar_70.y))
         +
          (tmpvar_70.z * tmpvar_70.z)
        )));
      };
      distance_69 = (blobStickiness - distance_69);
      highp float tmpvar_71;
      tmpvar_71 = (((
        (sin((deformationFrequency * point_67.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_67.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_67.z))
       * deformationAmount)) + distance_69);
      distance_69 = tmpvar_71;
      highp vec3 point_72;
      point_72 = (point_20 - vec3(0.0, 0.0, 0.001));
      highp float distance_74;
      distance_74 = 0.0;
      for (highp int i_73 = 0; i_73 < 20; i_73++) {
        highp vec3 tmpvar_75;
        tmpvar_75 = (point_72 - objects[i_73].xyz);
        distance_74 = (distance_74 + (objects[i_73].w / (
          ((tmpvar_75.x * tmpvar_75.x) + (tmpvar_75.y * tmpvar_75.y))
         +
          (tmpvar_75.z * tmpvar_75.z)
        )));
      };
      distance_74 = (blobStickiness - distance_74);
      highp float tmpvar_76;
      tmpvar_76 = (((
        (sin((deformationFrequency * point_72.x)) * deformationAmount)
       *
        (sin((deformationFrequency * point_72.y)) * deformationAmount)
      ) * (
        sin((deformationFrequency * point_72.z))
       * deformationAmount)) + distance_74);
      distance_74 = tmpvar_76;
      highp vec3 tmpvar_77;
      tmpvar_77.x = (tmpvar_51 - tmpvar_56);
      tmpvar_77.y = (tmpvar_61 - tmpvar_66);
      tmpvar_77.z = (tmpvar_71 - tmpvar_76);
      tmpvar_18 = bool(1);
      tmpvar_19 = normalize(tmpvar_77);
    };
  };
  color_2 = backgroundColor;
  if (tmpvar_18) {
    highp vec3 refractionColor_78;
    highp vec3 color_79;
    color_79 = vec3(0.0, 0.0, 0.0);
    highp vec3 tmpvar_80;
    highp float tmpvar_81;
    tmpvar_81 = dot (tmpvar_19, tmpvar_17);
    highp float tmpvar_82;
    tmpvar_82 = (1.0 - ((1.0 -
      (tmpvar_81 * tmpvar_81)
    ) * 0.9604));
    if ((tmpvar_82 < 0.0)) {
      tmpvar_80 = vec3(0.0, 0.0, 0.0);
    } else {
      tmpvar_80 = ((0.98 * tmpvar_17) - ((
        (0.98 * tmpvar_81)
       +
        sqrt(tmpvar_82)
      ) * tmpvar_19));
    };
    highp vec3 tmpvar_83;
    tmpvar_83 = normalize(tmpvar_80);
    highp float tmpvar_84;
    tmpvar_84 = dot (tmpvar_83, vec3(0.0, 2.0, 0.0));
    highp float tmpvar_85;
    tmpvar_85 = dot (tmpvar_83, vec3(-2.0, 0.5, 0.0));
    refractionColor_78 = ((clamp (
      (vec3(max (pow (clamp (
        (sin(tmpvar_84) + 1.0)
      , 0.0, 1.0), 0.15), 0.5)) * baseLightColor)
    , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)) + clamp (
      (vec3((pow (clamp (
        (sin(tmpvar_84) - 0.83)
      , 0.0, 1.0), 0.2) * pow ((
        sin(tmpvar_84)
       - 0.9), 0.4))) * spotLightColor)
    , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0))) + clamp ((vec3(
      (pow (clamp ((
        sin(tmpvar_85)
       - 0.9), 0.0, 1.0), 0.3) * pow ((sin(tmpvar_85) - 0.9), 0.4))
    ) * spot2LightColor), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)));
    refractionColor_78 = (refractionColor_78 * objectColor);
    highp vec3 tmpvar_86;
    tmpvar_86 = normalize((tmpvar_17 - (2.0 *
      (dot (tmpvar_19, tmpvar_17) * tmpvar_19)
    )));
    highp float tmpvar_87;
    tmpvar_87 = dot (tmpvar_86, vec3(0.0, 2.0, 0.0));
    highp float tmpvar_88;
    tmpvar_88 = dot (tmpvar_86, vec3(-2.0, 0.5, 0.0));
    color_79 = ((3.0 * (
      mix (refractionColor_78, ((clamp (
        (vec3(max (pow (clamp (
          (sin(tmpvar_87) + 1.0)
        , 0.0, 1.0), 0.15), 0.5)) * baseLightColor)
      , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)) + clamp (
        (vec3((pow (clamp (
          (sin(tmpvar_87) - 0.83)
        , 0.0, 1.0), 0.2) * pow ((
          sin(tmpvar_87)
         - 0.9), 0.4))) * spotLightColor)
      , vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0))) + clamp ((vec3(
        (pow (clamp ((
          sin(tmpvar_88)
         - 0.9), 0.0, 1.0), 0.3) * pow ((sin(tmpvar_88) - 0.9), 0.4))
      ) * spot2LightColor), vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0))), 0.5)
     - vec3(0.5, 0.5, 0.5))) + vec3(0.5, 0.5, 0.5));
    color_2 = color_79;
  };
  halftoneColor_1 = (max (color_2, vec3(0.3, 0.3, 0.3)) * tmpvar_16);
  halftoneColor_1 = (pow (halftoneColor_1, vec3(halftonePrePower)) * vec3(halftoneMultiplier));
  highp vec3 tmpvar_89;
  tmpvar_89 = pow (clamp (halftoneColor_1, vec3(0.0, 0.0, 0.0), vec3(1.0, 1.0, 1.0)), vec3(halftonePostPower));
  halftoneColor_1 = tmpvar_89;
  highp vec3 tmpvar_90;
  tmpvar_90 = mix (mix (gradientBottomColor, gradientTopColor, (gl_FragCoord.xy / resolution).yyy), vec3(1.0, 1.0, 1.0), vec3(greaterThanEqual (
    mix (tmpvar_89, vec3(1.0, 1.0, 1.0), vec3(greaterThanEqual (color_2, vec3(1.0, 1.0, 1.0))))
  , vec3(1.0, 1.0, 1.0))));
  color_2 = tmpvar_90;
  highp vec4 tmpvar_91;
  tmpvar_91.w = 1.0;
  tmpvar_91.xyz = tmpvar_90;
  gl_FragColor = tmpvar_91;
}


// stats: 404 alu 0 tex 26 flow
// inputs: 1
//  #0: gl_FragCoord (high float) 4x1 [-1] loc 0
// uniforms: 19 (total size: 0)
//  #0: resolution (high float) 2x1 [-1]
//  #1: objectColor (high float) 3x1 [-1]
//  #2: backgroundColor (high float) 3x1 [-1]
//  #3: baseLightColor (high float) 3x1 [-1]
//  #4: spotLightColor (high float) 3x1 [-1]
//  #5: spot2LightColor (high float) 3x1 [-1]
//  #6: blobStickiness (high float) 1x1 [-1]
//  #7: gradientTopColor (high float) 3x1 [-1]
//  #8: gradientBottomColor (high float) 3x1 [-1]
//  #9: deformationFrequency (high float) 1x1 [-1]
//  #10: deformationAmount (high float) 1x1 [-1]
//  #11: halftoneGridSize (high float) 1x1 [-1]
//  #12: halftoneSeparation (high float) 1x1 [-1]
//  #13: halftonePrePower (high float) 1x1 [-1]
//  #14: halftonePostPower (high float) 1x1 [-1]
//  #15: halftoneMultiplier (high float) 1x1 [-1]
//  #16: zoom (high float) 1x1 [-1]
//  #17: camera (high float) 3x1 [-1]
//  #18: objects (high float) 4x1 [20]
