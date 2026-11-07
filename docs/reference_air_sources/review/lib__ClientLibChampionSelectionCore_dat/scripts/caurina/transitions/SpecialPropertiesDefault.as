package caurina.transitions
{
   import flash.filters.BitmapFilter;
   import flash.filters.BlurFilter;
   import flash.geom.ColorTransform;
   import flash.media.SoundTransform;
   
   public class SpecialPropertiesDefault
   {
      
      public function SpecialPropertiesDefault()
      {
         super();
         trace("SpecialProperties is a static class and should not be instantiated.");
      }
      
      public static function _sound_volume_get(p_obj:Object) : Number
      {
         return p_obj.soundTransform.volume;
      }
      
      public static function _color_splitter(p_value:*, p_parameters:Array) : Array
      {
         var nArray:Array = null;
         nArray = new Array();
         if(p_value == null)
         {
            nArray.push({
               "name":"_color_ra",
               "value":1
            });
            nArray.push({
               "name":"_color_rb",
               "value":0
            });
            nArray.push({
               "name":"_color_ga",
               "value":1
            });
            nArray.push({
               "name":"_color_gb",
               "value":0
            });
            nArray.push({
               "name":"_color_ba",
               "value":1
            });
            nArray.push({
               "name":"_color_bb",
               "value":0
            });
         }
         else
         {
            nArray.push({
               "name":"_color_ra",
               "value":0
            });
            nArray.push({
               "name":"_color_rb",
               "value":AuxFunctions.numberToR(p_value)
            });
            nArray.push({
               "name":"_color_ga",
               "value":0
            });
            nArray.push({
               "name":"_color_gb",
               "value":AuxFunctions.numberToG(p_value)
            });
            nArray.push({
               "name":"_color_ba",
               "value":0
            });
            nArray.push({
               "name":"_color_bb",
               "value":AuxFunctions.numberToB(p_value)
            });
         }
         return nArray;
      }
      
      public static function frame_get(p_obj:Object) : Number
      {
         return p_obj.currentFrame;
      }
      
      public static function _sound_pan_get(p_obj:Object) : Number
      {
         return p_obj.soundTransform.pan;
      }
      
      public static function _color_property_get(p_obj:Object, p_parameters:Array) : Number
      {
         return p_obj.transform.colorTransform[p_parameters[0]];
      }
      
      public static function _sound_volume_set(p_obj:Object, p_value:Number) : void
      {
         var sndTransform:SoundTransform = null;
         sndTransform = p_obj.soundTransform;
         sndTransform.volume = p_value;
         p_obj.soundTransform = sndTransform;
      }
      
      public static function _autoAlpha_get(p_obj:Object) : Number
      {
         return p_obj.alpha;
      }
      
      public static function _filter_splitter(p_value:BitmapFilter, p_parameters:Array) : Array
      {
         var nArray:Array = null;
         nArray = new Array();
         if(p_value is BlurFilter)
         {
            nArray.push({
               "name":"_blur_blurX",
               "value":BlurFilter(p_value).blurX
            });
            nArray.push({
               "name":"_blur_blurY",
               "value":BlurFilter(p_value).blurY
            });
            nArray.push({
               "name":"_blur_quality",
               "value":BlurFilter(p_value).quality
            });
         }
         else
         {
            trace("??");
         }
         return nArray;
      }
      
      public static function init() : void
      {
         Tweener.registerSpecialProperty("_frame",frame_get,frame_set);
         Tweener.registerSpecialProperty("_sound_volume",_sound_volume_get,_sound_volume_set);
         Tweener.registerSpecialProperty("_sound_pan",_sound_pan_get,_sound_pan_set);
         Tweener.registerSpecialProperty("_color_ra",_color_property_get,_color_property_set,["redMultiplier"]);
         Tweener.registerSpecialProperty("_color_rb",_color_property_get,_color_property_set,["redOffset"]);
         Tweener.registerSpecialProperty("_color_ga",_color_property_get,_color_property_set,["greenMultiplier"]);
         Tweener.registerSpecialProperty("_color_gb",_color_property_get,_color_property_set,["greenOffset"]);
         Tweener.registerSpecialProperty("_color_ba",_color_property_get,_color_property_set,["blueMultiplier"]);
         Tweener.registerSpecialProperty("_color_bb",_color_property_get,_color_property_set,["blueOffset"]);
         Tweener.registerSpecialProperty("_color_aa",_color_property_get,_color_property_set,["alphaMultiplier"]);
         Tweener.registerSpecialProperty("_color_ab",_color_property_get,_color_property_set,["alphaOffset"]);
         Tweener.registerSpecialProperty("_autoAlpha",_autoAlpha_get,_autoAlpha_set);
         Tweener.registerSpecialPropertySplitter("_color",_color_splitter);
         Tweener.registerSpecialPropertySplitter("_colorTransform",_colorTransform_splitter);
         Tweener.registerSpecialPropertySplitter("_scale",_scale_splitter);
         Tweener.registerSpecialProperty("_blur_blurX",_filter_property_get,_filter_property_set,[BlurFilter,"blurX"]);
         Tweener.registerSpecialProperty("_blur_blurY",_filter_property_get,_filter_property_set,[BlurFilter,"blurY"]);
         Tweener.registerSpecialProperty("_blur_quality",_filter_property_get,_filter_property_set,[BlurFilter,"quality"]);
         Tweener.registerSpecialPropertySplitter("_filter",_filter_splitter);
         Tweener.registerSpecialPropertyModifier("_bezier",_bezier_modifier,_bezier_get);
      }
      
      public static function _sound_pan_set(p_obj:Object, p_value:Number) : void
      {
         var sndTransform:SoundTransform = null;
         sndTransform = p_obj.soundTransform;
         sndTransform.pan = p_value;
         p_obj.soundTransform = sndTransform;
      }
      
      public static function _color_property_set(p_obj:Object, p_value:Number, p_parameters:Array) : void
      {
         var tf:ColorTransform = null;
         tf = p_obj.transform.colorTransform;
         tf[p_parameters[0]] = p_value;
         p_obj.transform.colorTransform = tf;
      }
      
      public static function _filter_property_get(p_obj:Object, p_parameters:Array) : Number
      {
         var f:Array = null;
         var i:uint = 0;
         var filterClass:Object = null;
         var propertyName:String = null;
         var defaultValues:Object = null;
         f = p_obj.filters;
         filterClass = p_parameters[0];
         propertyName = p_parameters[1];
         for(i = 0; i < f.length; i++)
         {
            if(f[i] is BlurFilter && filterClass == BlurFilter)
            {
               return f[i][propertyName];
            }
         }
         switch(filterClass)
         {
            case BlurFilter:
               defaultValues = {
                  "blurX":0,
                  "blurY":0,
                  "quality":NaN
               };
         }
         return defaultValues[propertyName];
      }
      
      public static function _bezier_get(b:Number, e:Number, t:Number, p:Array) : Number
      {
         var ip:uint = 0;
         var it:Number = NaN;
         var p1:Number = NaN;
         var p2:Number = NaN;
         if(p.length == 1)
         {
            return b + t * (2 * (1 - t) * (p[0] - b) + t * (e - b));
         }
         ip = Math.floor(t * p.length);
         it = (t - ip * (1 / p.length)) * p.length;
         if(ip == 0)
         {
            p1 = b;
            p2 = (p[0] + p[1]) / 2;
         }
         else if(ip == p.length - 1)
         {
            p1 = (p[ip - 1] + p[ip]) / 2;
            p2 = e;
         }
         else
         {
            p1 = (p[ip - 1] + p[ip]) / 2;
            p2 = (p[ip] + p[ip + 1]) / 2;
         }
         return p1 + it * (2 * (1 - it) * (p[ip] - p1) + it * (p2 - p1));
      }
      
      public static function frame_set(p_obj:Object, p_value:Number) : void
      {
         p_obj.gotoAndStop(Math.round(p_value));
      }
      
      public static function _filter_property_set(p_obj:Object, p_value:Number, p_parameters:Array) : void
      {
         var f:Array = null;
         var i:uint = 0;
         var filterClass:Object = null;
         var propertyName:String = null;
         var fi:BitmapFilter = null;
         f = p_obj.filters;
         filterClass = p_parameters[0];
         propertyName = p_parameters[1];
         for(i = 0; i < f.length; i++)
         {
            if(f[i] is BlurFilter && filterClass == BlurFilter)
            {
               f[i][propertyName] = p_value;
               p_obj.filters = f;
               return;
            }
         }
         if(f == null)
         {
            f = new Array();
         }
         switch(filterClass)
         {
            case BlurFilter:
               fi = new BlurFilter(0,0);
         }
         fi[propertyName] = p_value;
         f.push(fi);
         p_obj.filters = f;
      }
      
      public static function _autoAlpha_set(p_obj:Object, p_value:Number) : void
      {
         p_obj.alpha = p_value;
         p_obj.visible = p_value > 0;
      }
      
      public static function _scale_splitter(p_value:Number, p_parameters:Array) : Array
      {
         var nArray:Array = null;
         nArray = new Array();
         nArray.push({
            "name":"scaleX",
            "value":p_value
         });
         nArray.push({
            "name":"scaleY",
            "value":p_value
         });
         return nArray;
      }
      
      public static function _colorTransform_splitter(p_value:*, p_parameters:Array) : Array
      {
         var nArray:Array = null;
         nArray = new Array();
         if(p_value == null)
         {
            nArray.push({
               "name":"_color_ra",
               "value":1
            });
            nArray.push({
               "name":"_color_rb",
               "value":0
            });
            nArray.push({
               "name":"_color_ga",
               "value":1
            });
            nArray.push({
               "name":"_color_gb",
               "value":0
            });
            nArray.push({
               "name":"_color_ba",
               "value":1
            });
            nArray.push({
               "name":"_color_bb",
               "value":0
            });
         }
         else
         {
            if(p_value.ra != undefined)
            {
               nArray.push({
                  "name":"_color_ra",
                  "value":p_value.ra
               });
            }
            if(p_value.rb != undefined)
            {
               nArray.push({
                  "name":"_color_rb",
                  "value":p_value.rb
               });
            }
            if(p_value.ga != undefined)
            {
               nArray.push({
                  "name":"_color_ba",
                  "value":p_value.ba
               });
            }
            if(p_value.gb != undefined)
            {
               nArray.push({
                  "name":"_color_bb",
                  "value":p_value.bb
               });
            }
            if(p_value.ba != undefined)
            {
               nArray.push({
                  "name":"_color_ga",
                  "value":p_value.ga
               });
            }
            if(p_value.bb != undefined)
            {
               nArray.push({
                  "name":"_color_gb",
                  "value":p_value.gb
               });
            }
            if(p_value.aa != undefined)
            {
               nArray.push({
                  "name":"_color_aa",
                  "value":p_value.aa
               });
            }
            if(p_value.ab != undefined)
            {
               nArray.push({
                  "name":"_color_ab",
                  "value":p_value.ab
               });
            }
         }
         return nArray;
      }
      
      public static function _bezier_modifier(p_obj:*) : Array
      {
         var mList:Array = null;
         var pList:Array = null;
         var i:uint = 0;
         var istr:String = null;
         var mListObj:Object = null;
         mList = [];
         if(p_obj is Array)
         {
            pList = p_obj;
         }
         else
         {
            pList = [p_obj];
         }
         mListObj = {};
         for(i = 0; i < pList.length; i++)
         {
            for(istr in pList[i])
            {
               if(mListObj[istr] == undefined)
               {
                  mListObj[istr] = [];
               }
               mListObj[istr].push(pList[i][istr]);
            }
         }
         for(istr in mListObj)
         {
            mList.push({
               "name":istr,
               "parameters":mListObj[istr]
            });
         }
         return mList;
      }
   }
}

