package mx.controls.videoClasses
{
   import flash.events.Event;
   import mx.controls.VideoDisplay;
   import mx.core.mx_internal;
   import mx.events.MetadataEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ResourceBundle("controls")]
   public class CuePointManager
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static var DEFAULT_LINEAR_SEARCH_TOLERANCE:Number = 50;
      
      mx_internal var videoDisplay:VideoDisplay;
      
      private var _disabledCuePointsByNameOnly:Object;
      
      private var _disabledCuePoints:Array;
      
      private var _linearSearchTolerance:Number;
      
      private var _cuePointTolerance:Number;
      
      private var _owner:VideoPlayer;
      
      private var cuePoints:Array;
      
      private var _metadataLoaded:Boolean;
      
      private var _cuePointIndex:uint;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function CuePointManager(owner:VideoPlayer, id:uint = 0)
      {
         super();
         _owner = owner;
         reset();
         _cuePointTolerance = _owner.playheadUpdateInterval / 2000;
         _linearSearchTolerance = DEFAULT_LINEAR_SEARCH_TOLERANCE;
      }
      
      private static function deepCopyObject(obj:Object, recurseLevel:Number = 0) : Object
      {
         var i:Object = null;
         if(obj == null || typeof obj != "object")
         {
            return obj;
         }
         if(isNaN(recurseLevel))
         {
            recurseLevel = 0;
         }
         var newObj:Object = {};
         for(i in obj)
         {
            if(!(recurseLevel == 0 && (i == "array" || i == "index")))
            {
               if(typeof obj[i] == "object")
               {
                  newObj[i] = deepCopyObject(obj[i],recurseLevel + 1);
               }
               else
               {
                  newObj[i] = obj[i];
               }
            }
         }
         return newObj;
      }
      
      private static function cuePointCompare(time:Number, name:String, cuePoint:Object) : Number
      {
         var compTime1:Number = Math.round(time * 1000);
         var compTime2:Number = Math.round(cuePoint.time * 1000);
         if(compTime1 < compTime2)
         {
            return -1;
         }
         if(compTime1 > compTime2)
         {
            return 1;
         }
         if(name != null)
         {
            if(name == cuePoint.name)
            {
               return 0;
            }
            if(name < cuePoint.name)
            {
               return -1;
            }
            return 1;
         }
         return 0;
      }
      
      public function getCuePoints() : Array
      {
         return cuePoints;
      }
      
      public function removeCuePoint(cuePoint:Object) : Object
      {
         if(cuePoints == null || cuePoints.length < 1)
         {
            return null;
         }
         var index:Number = getCuePointIndex(cuePoints,false,cuePoint.time,cuePoint.name,0,0);
         if(index < 0)
         {
            return null;
         }
         cuePoint = cuePoints[index];
         cuePoints.splice(index,1);
         if(_owner.playheadTime > 0)
         {
            if(_cuePointIndex > index)
            {
               --_cuePointIndex;
            }
         }
         else
         {
            _cuePointIndex = 0;
         }
         videoDisplay.dispatchEvent(new Event("cuePointsChanged"));
         return cuePoint;
      }
      
      public function setCuePoints(cuePointArray:Array) : void
      {
         if(cuePointArray == null)
         {
            return;
         }
         for(var index:uint = 0; index < cuePointArray.length; index++)
         {
            addCuePoint(cuePointArray[index]);
         }
      }
      
      private function set playheadUpdateInterval(aTime:Number) : void
      {
         _cuePointTolerance = aTime / 2000;
      }
      
      private function getCuePointIndex(cuePointArray:Array, closeIsOK:Boolean, time:Number, name:String, start:Number, len:Number) : Number
      {
         var result:Number = NaN;
         var message:String = null;
         var firstIndex:Number = NaN;
         var index:Number = NaN;
         var max:Number = NaN;
         var i:uint = 0;
         if(cuePointArray == null || cuePointArray.length < 1)
         {
            return -1;
         }
         var timeUndefined:Boolean = isNaN(time) || time < 0;
         if(timeUndefined && !name)
         {
            message = resourceManager.getString("controls","wrongTimeName");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(len == 0)
         {
            len = cuePointArray.length;
         }
         if(Boolean(name) && (closeIsOK || timeUndefined))
         {
            if(timeUndefined)
            {
               firstIndex = start;
            }
            else
            {
               firstIndex = getCuePointIndex(cuePointArray,closeIsOK,time,null,0,0);
            }
            for(index = firstIndex; index >= start; index--)
            {
               if(cuePointArray[index].name == name)
               {
                  break;
               }
            }
            if(index >= start)
            {
               return index;
            }
            for(index = firstIndex + 1; index < len; index++)
            {
               if(cuePointArray[index].name == name)
               {
                  break;
               }
            }
            if(index < len)
            {
               return index;
            }
            return -1;
         }
         if(len <= _linearSearchTolerance)
         {
            max = start + len;
            for(i = start; i < max; i++)
            {
               result = cuePointCompare(time,name,cuePointArray[i]);
               if(result == 0)
               {
                  return i;
               }
               if(result < 0)
               {
                  break;
               }
            }
            if(closeIsOK)
            {
               if(i > 0)
               {
                  return i - 1;
               }
               return 0;
            }
            return -1;
         }
         var halfLen:Number = Math.floor(len / 2);
         var checkIndex:Number = start + halfLen;
         result = cuePointCompare(time,name,cuePointArray[checkIndex]);
         if(result < 0)
         {
            return getCuePointIndex(cuePointArray,closeIsOK,time,name,start,halfLen);
         }
         if(result > 0)
         {
            return getCuePointIndex(cuePointArray,closeIsOK,time,name,checkIndex + 1,halfLen - 1 + len % 2);
         }
         return checkIndex;
      }
      
      private function reset() : void
      {
         _metadataLoaded = false;
         cuePoints = null;
         _disabledCuePoints = null;
         _cuePointIndex = 0;
      }
      
      private function getCuePoint(cuePointArray:Array, closeIsOK:Boolean, timeNameOrCuePoint:Object = null) : Object
      {
         var cuePoint:Object = null;
         switch(typeof timeNameOrCuePoint)
         {
            case "string":
               cuePoint = {"name":timeNameOrCuePoint};
               break;
            case "number":
               cuePoint = {"time":timeNameOrCuePoint};
               break;
            case "object":
               cuePoint = timeNameOrCuePoint;
         }
         var index:Number = getCuePointIndex(cuePointArray,closeIsOK,cuePoint.time,cuePoint.name,0,0);
         if(index < 0)
         {
            return null;
         }
         cuePoint = deepCopyObject(cuePointArray[index]);
         cuePoint.array = cuePointArray;
         cuePoint.index = index;
         return cuePoint;
      }
      
      private function get metadataLoaded() : Boolean
      {
         return _metadataLoaded;
      }
      
      private function insertCuePoint(insertIndex:Number, cuePointArray:Array, cuePoint:Object) : Array
      {
         if(insertIndex < 0)
         {
            cuePointArray = [];
            cuePointArray.push(cuePoint);
         }
         else
         {
            if(cuePointArray[insertIndex].time > cuePoint.time)
            {
               insertIndex = 0;
            }
            else
            {
               insertIndex++;
            }
            cuePointArray.splice(insertIndex,0,cuePoint);
         }
         return cuePointArray;
      }
      
      private function removeCuePoints(cuePointArray:Array, cuePoint:Object) : Number
      {
         var matchIndex:Number = NaN;
         var matchCuePoint:Object = null;
         var numChanged:Number = 0;
         for(matchIndex = getCuePointIndex(cuePointArray,true,-1,cuePoint.name,0,0); matchIndex >= 0; )
         {
            matchCuePoint = cuePointArray[matchIndex];
            cuePointArray.splice(matchIndex,1);
            matchIndex--;
            numChanged++;
            matchIndex = getNextCuePointIndexWithName(matchCuePoint.name,cuePointArray,matchIndex);
         }
         return numChanged;
      }
      
      mx_internal function dispatchCuePoints() : void
      {
         var metadataEvent:MetadataEvent = null;
         var now:Number = _owner.playheadTime;
         if(_owner.stateResponsive && cuePoints != null)
         {
            while(_cuePointIndex < cuePoints.length && cuePoints[_cuePointIndex].time <= now + _cuePointTolerance)
            {
               metadataEvent = new MetadataEvent(MetadataEvent.CUE_POINT);
               metadataEvent.info = deepCopyObject(cuePoints[_cuePointIndex++]);
               _owner.dispatchEvent(metadataEvent);
            }
         }
      }
      
      private function getNextCuePointIndexWithName(name:String, array:Array, index:Number) : Number
      {
         var message:String = null;
         var i:int = 0;
         if(!name)
         {
            message = resourceManager.getString("controls","wrongName");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(!array)
         {
            message = resourceManager.getString("controls","undefinedArray");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(isNaN(index) || index < -1 || index >= array.length)
         {
            message = resourceManager.getString("controls","wrongIndex");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         for(i = index + 1; i < array.length; i++)
         {
            if(array[i].name == name)
            {
               break;
            }
         }
         if(i < array.length)
         {
            return i;
         }
         return -1;
      }
      
      public function addCuePoint(cuePoint:Object) : Object
      {
         var message:String = null;
         var index:Number = NaN;
         var copy:Object = deepCopyObject(cuePoint);
         var timeUndefined:Boolean = isNaN(copy.time) || copy.time < 0;
         if(timeUndefined)
         {
            message = resourceManager.getString("controls","wrongTime");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(!copy.name)
         {
            message = resourceManager.getString("controls","wrongName");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         copy.type = "actionscript";
         if(cuePoints == null || cuePoints.length < 1)
         {
            index = 0;
            cuePoints = [];
            cuePoints.push(copy);
         }
         else
         {
            index = getCuePointIndex(cuePoints,true,copy.time,null,0,0);
            index = cuePoints[index].time > copy.time ? 0 : index + 1;
            cuePoints.splice(index,0,copy);
         }
         var now:Number = _owner.playheadTime;
         if(now > 0)
         {
            if(_cuePointIndex == index)
            {
               if(now > cuePoints[index].time)
               {
                  ++_cuePointIndex;
               }
            }
            else if(_cuePointIndex > index)
            {
               ++_cuePointIndex;
            }
         }
         else
         {
            _cuePointIndex = 0;
         }
         var returnObject:Object = deepCopyObject(cuePoints[index]);
         returnObject.array = cuePoints;
         returnObject.index = index;
         videoDisplay.dispatchEvent(new Event("cuePointsChanged"));
         return returnObject;
      }
      
      mx_internal function resetCuePointIndex(time:Number) : void
      {
         if(time <= 0 || cuePoints == null)
         {
            _cuePointIndex = 0;
            return;
         }
         var index:Number = getCuePointIndex(cuePoints,true,time,null,0,0);
         _cuePointIndex = cuePoints[index].time < time ? uint(index + 1) : uint(index);
      }
      
      public function getCuePointByName(name:String) : Object
      {
         return getCuePoint(cuePoints,false,name);
      }
      
      private function getNextCuePointWithName(cuePoint:Object) : Object
      {
         var message:String = null;
         if(!cuePoint)
         {
            message = resourceManager.getString("controls","undefinedParameter");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(isNaN(cuePoint.time) || cuePoint.time < 0)
         {
            message = resourceManager.getString("controls","wrongTime");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         var index:Number = getNextCuePointIndexWithName(cuePoint.name,cuePoint.array,cuePoint.index);
         if(index < 0)
         {
            return null;
         }
         var returnCuePoint:Object = deepCopyObject(cuePoint.array[index]);
         returnCuePoint.array = cuePoint.array;
         returnCuePoint.index = index;
         return returnCuePoint;
      }
      
      public function removeAllCuePoints() : void
      {
         cuePoints = null;
         videoDisplay.dispatchEvent(new Event("cuePointsChanged"));
      }
   }
}

