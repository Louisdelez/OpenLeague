package mx.controls.videoClasses
{
   import flash.events.Event;
   import mx.controls.VideoDisplay;
   import mx.events.MetadataEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("controls")]
   public class CuePointManager
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var DEFAULT_LINEAR_SEARCH_TOLERANCE:Number = 50;
      
      private var _owner:VideoPlayer;
      
      private var _metadataLoaded:Boolean;
      
      private var _disabledCuePoints:Array;
      
      private var _disabledCuePointsByNameOnly:Object;
      
      private var _cuePointIndex:uint;
      
      private var _cuePointTolerance:Number;
      
      private var _linearSearchTolerance:Number;
      
      private var cuePoints:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var videoDisplay:VideoDisplay;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function CuePointManager(owner:VideoPlayer, id:uint = 0)
      {
         super();
         this._owner = owner;
         this.reset();
         this._cuePointTolerance = this._owner.playheadUpdateInterval / 2000;
         this._linearSearchTolerance = DEFAULT_LINEAR_SEARCH_TOLERANCE;
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
      
      private function reset() : void
      {
         this._metadataLoaded = false;
         this.cuePoints = null;
         this._disabledCuePoints = null;
         this._cuePointIndex = 0;
      }
      
      private function get metadataLoaded() : Boolean
      {
         return this._metadataLoaded;
      }
      
      private function set playheadUpdateInterval(aTime:Number) : void
      {
         this._cuePointTolerance = aTime / 2000;
      }
      
      public function addCuePoint(cuePoint:Object) : Object
      {
         var message:String = null;
         var index:Number = NaN;
         var copy:Object = deepCopyObject(cuePoint);
         var timeUndefined:Boolean = isNaN(copy.time) || copy.time < 0;
         if(timeUndefined)
         {
            message = this.resourceManager.getString("controls","wrongTime");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(!copy.name)
         {
            message = this.resourceManager.getString("controls","wrongName");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         copy.type = "actionscript";
         if(this.cuePoints == null || this.cuePoints.length < 1)
         {
            index = 0;
            this.cuePoints = [];
            this.cuePoints.push(copy);
         }
         else
         {
            index = this.getCuePointIndex(this.cuePoints,true,copy.time,null,0,0);
            index = this.cuePoints[index].time > copy.time ? 0 : index + 1;
            this.cuePoints.splice(index,0,copy);
         }
         var now:Number = this._owner.playheadTime;
         if(now > 0)
         {
            if(this._cuePointIndex == index)
            {
               if(now > this.cuePoints[index].time)
               {
                  ++this._cuePointIndex;
               }
            }
            else if(this._cuePointIndex > index)
            {
               ++this._cuePointIndex;
            }
         }
         else
         {
            this._cuePointIndex = 0;
         }
         var returnObject:Object = deepCopyObject(this.cuePoints[index]);
         returnObject.array = this.cuePoints;
         returnObject.index = index;
         this.videoDisplay.dispatchEvent(new Event("cuePointsChanged"));
         return returnObject;
      }
      
      public function removeCuePoint(cuePoint:Object) : Object
      {
         if(this.cuePoints == null || this.cuePoints.length < 1)
         {
            return null;
         }
         var index:Number = this.getCuePointIndex(this.cuePoints,false,cuePoint.time,cuePoint.name,0,0);
         if(index < 0)
         {
            return null;
         }
         cuePoint = this.cuePoints[index];
         this.cuePoints.splice(index,1);
         if(this._owner.playheadTime > 0)
         {
            if(this._cuePointIndex > index)
            {
               --this._cuePointIndex;
            }
         }
         else
         {
            this._cuePointIndex = 0;
         }
         this.videoDisplay.dispatchEvent(new Event("cuePointsChanged"));
         return cuePoint;
      }
      
      private function removeCuePoints(cuePointArray:Array, cuePoint:Object) : Number
      {
         var matchIndex:Number = NaN;
         var matchCuePoint:Object = null;
         var numChanged:Number = 0;
         for(matchIndex = this.getCuePointIndex(cuePointArray,true,-1,cuePoint.name,0,0); matchIndex >= 0; )
         {
            matchCuePoint = cuePointArray[matchIndex];
            cuePointArray.splice(matchIndex,1);
            matchIndex--;
            numChanged++;
            matchIndex = this.getNextCuePointIndexWithName(matchCuePoint.name,cuePointArray,matchIndex);
         }
         return numChanged;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function dispatchCuePoints() : void
      {
         var metadataEvent:MetadataEvent = null;
         var now:Number = this._owner.playheadTime;
         if(this._owner.stateResponsive && this.cuePoints != null)
         {
            while(this._cuePointIndex < this.cuePoints.length && this.cuePoints[this._cuePointIndex].time <= now + this._cuePointTolerance)
            {
               metadataEvent = new MetadataEvent(MetadataEvent.CUE_POINT);
               metadataEvent.info = deepCopyObject(this.cuePoints[this._cuePointIndex++]);
               this._owner.dispatchEvent(metadataEvent);
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resetCuePointIndex(time:Number) : void
      {
         if(time <= 0 || this.cuePoints == null)
         {
            this._cuePointIndex = 0;
            return;
         }
         var index:Number = this.getCuePointIndex(this.cuePoints,true,time,null,0,0);
         this._cuePointIndex = this.cuePoints[index].time < time ? uint(index + 1) : uint(index);
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
            message = this.resourceManager.getString("controls","wrongTimeName");
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
               firstIndex = this.getCuePointIndex(cuePointArray,closeIsOK,time,null,0,0);
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
         if(len <= this._linearSearchTolerance)
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
            return this.getCuePointIndex(cuePointArray,closeIsOK,time,name,start,halfLen);
         }
         if(result > 0)
         {
            return this.getCuePointIndex(cuePointArray,closeIsOK,time,name,checkIndex + 1,halfLen - 1 + len % 2);
         }
         return checkIndex;
      }
      
      private function getNextCuePointIndexWithName(name:String, array:Array, index:Number) : Number
      {
         var message:String = null;
         var i:int = 0;
         if(!name)
         {
            message = this.resourceManager.getString("controls","wrongName");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(!array)
         {
            message = this.resourceManager.getString("controls","undefinedArray");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(isNaN(index) || index < -1 || index >= array.length)
         {
            message = this.resourceManager.getString("controls","wrongIndex");
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
         var index:Number = this.getCuePointIndex(cuePointArray,closeIsOK,cuePoint.time,cuePoint.name,0,0);
         if(index < 0)
         {
            return null;
         }
         cuePoint = deepCopyObject(cuePointArray[index]);
         cuePoint.array = cuePointArray;
         cuePoint.index = index;
         return cuePoint;
      }
      
      private function getNextCuePointWithName(cuePoint:Object) : Object
      {
         var message:String = null;
         if(!cuePoint)
         {
            message = this.resourceManager.getString("controls","undefinedParameter");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         if(isNaN(cuePoint.time) || cuePoint.time < 0)
         {
            message = this.resourceManager.getString("controls","wrongTime");
            throw new VideoError(VideoError.ILLEGAL_CUE_POINT,message);
         }
         var index:Number = this.getNextCuePointIndexWithName(cuePoint.name,cuePoint.array,cuePoint.index);
         if(index < 0)
         {
            return null;
         }
         var returnCuePoint:Object = deepCopyObject(cuePoint.array[index]);
         returnCuePoint.array = cuePoint.array;
         returnCuePoint.index = index;
         return returnCuePoint;
      }
      
      public function getCuePointByName(name:String) : Object
      {
         return this.getCuePoint(this.cuePoints,false,name);
      }
      
      public function getCuePoints() : Array
      {
         return this.cuePoints;
      }
      
      public function removeAllCuePoints() : void
      {
         this.cuePoints = null;
         this.videoDisplay.dispatchEvent(new Event("cuePointsChanged"));
      }
      
      public function setCuePoints(cuePointArray:Array) : void
      {
         if(cuePointArray == null)
         {
            return;
         }
         for(var index:uint = 0; index < cuePointArray.length; index++)
         {
            this.addCuePoint(cuePointArray[index]);
         }
      }
   }
}

