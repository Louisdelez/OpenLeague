package caurina.transitions
{
   public class TweenListObj
   {
      
      public var onUpdate:Function;
      
      public var useFrames:Boolean;
      
      public var hasStarted:Boolean;
      
      public var onOverwriteParams:Array;
      
      public var timeStart:Number;
      
      public var count:Number;
      
      public var auxProperties:Object;
      
      public var timeComplete:Number;
      
      public var onStartParams:Array;
      
      public var rounded:Boolean;
      
      public var properties:Object;
      
      public var onUpdateParams:Array;
      
      public var onComplete:Function;
      
      public var updatesSkipped:Number;
      
      public var onStart:Function;
      
      public var skipUpdates:Number;
      
      public var scope:Object;
      
      public var isCaller:Boolean;
      
      public var timePaused:Number;
      
      public var transition:Function;
      
      public var onCompleteParams:Array;
      
      public var onError:Function;
      
      public var timesCalled:Number;
      
      public var onOverwrite:Function;
      
      public var isPaused:Boolean;
      
      public var waitFrames:Boolean;
      
      public function TweenListObj(p_scope:Object, p_timeStart:Number, p_timeComplete:Number, p_useFrames:Boolean, p_transition:Function)
      {
         super();
         scope = p_scope;
         timeStart = p_timeStart;
         timeComplete = p_timeComplete;
         useFrames = p_useFrames;
         transition = p_transition;
         auxProperties = new Object();
         properties = new Object();
         isPaused = false;
         timePaused = undefined;
         isCaller = false;
         updatesSkipped = 0;
         timesCalled = 0;
         skipUpdates = 0;
         hasStarted = false;
      }
      
      public static function makePropertiesChain(p_obj:Object) : Object
      {
         var baseObject:Object = null;
         var chainedObject:Object = null;
         var chain:Object = null;
         var currChainObj:Object = null;
         var len:Number = NaN;
         var i:Number = NaN;
         var k:Number = NaN;
         baseObject = p_obj.base;
         if(Boolean(baseObject))
         {
            chainedObject = {};
            if(baseObject is Array)
            {
               chain = [];
               k = 0;
               while(k < baseObject.length)
               {
                  chain.push(baseObject[k]);
                  k++;
               }
            }
            else
            {
               chain = [baseObject];
            }
            chain.push(p_obj);
            len = Number(chain.length);
            for(i = 0; i < len; i++)
            {
               if(Boolean(chain[i]["base"]))
               {
                  currChainObj = AuxFunctions.concatObjects(makePropertiesChain(chain[i]["base"]),chain[i]);
               }
               else
               {
                  currChainObj = chain[i];
               }
               chainedObject = AuxFunctions.concatObjects(chainedObject,currChainObj);
            }
            if(Boolean(chainedObject["base"]))
            {
               delete chainedObject["base"];
            }
            return chainedObject;
         }
         return p_obj;
      }
      
      public function clone(omitEvents:Boolean) : TweenListObj
      {
         var nTween:TweenListObj = null;
         var pName:String = null;
         nTween = new TweenListObj(scope,timeStart,timeComplete,useFrames,transition);
         nTween.properties = new Array();
         for(pName in properties)
         {
            nTween.properties[pName] = properties[pName].clone();
         }
         nTween.skipUpdates = skipUpdates;
         nTween.updatesSkipped = updatesSkipped;
         if(!omitEvents)
         {
            nTween.onStart = onStart;
            nTween.onUpdate = onUpdate;
            nTween.onComplete = onComplete;
            nTween.onOverwrite = onOverwrite;
            nTween.onError = onError;
            nTween.onStartParams = onStartParams;
            nTween.onUpdateParams = onUpdateParams;
            nTween.onCompleteParams = onCompleteParams;
            nTween.onOverwriteParams = onOverwriteParams;
         }
         nTween.rounded = rounded;
         nTween.isPaused = isPaused;
         nTween.timePaused = timePaused;
         nTween.isCaller = isCaller;
         nTween.count = count;
         nTween.timesCalled = timesCalled;
         nTween.waitFrames = waitFrames;
         nTween.hasStarted = hasStarted;
         return nTween;
      }
      
      public function toString() : String
      {
         var returnStr:String = null;
         var i:uint = 0;
         returnStr = "\n[TweenListObj ";
         returnStr += "scope:" + String(scope);
         returnStr += ", properties:";
         for(i = 0; i < properties.length; i++)
         {
            if(i > 0)
            {
               returnStr += ",";
            }
            returnStr += "[name:" + properties[i].name;
            returnStr += ",valueStart:" + properties[i].valueStart;
            returnStr += ",valueComplete:" + properties[i].valueComplete;
            returnStr += "]";
         }
         returnStr += ", timeStart:" + String(timeStart);
         returnStr += ", timeComplete:" + String(timeComplete);
         returnStr += ", useFrames:" + String(useFrames);
         returnStr += ", transition:" + String(transition);
         if(Boolean(skipUpdates))
         {
            returnStr += ", skipUpdates:" + String(skipUpdates);
         }
         if(Boolean(updatesSkipped))
         {
            returnStr += ", updatesSkipped:" + String(updatesSkipped);
         }
         if(Boolean(onStart))
         {
            returnStr += ", onStart:" + String(onStart);
         }
         if(Boolean(onUpdate))
         {
            returnStr += ", onUpdate:" + String(onUpdate);
         }
         if(Boolean(onComplete))
         {
            returnStr += ", onComplete:" + String(onComplete);
         }
         if(Boolean(onOverwrite))
         {
            returnStr += ", onOverwrite:" + String(onOverwrite);
         }
         if(Boolean(onError))
         {
            returnStr += ", onError:" + String(onError);
         }
         if(Boolean(onStartParams))
         {
            returnStr += ", onStartParams:" + String(onStartParams);
         }
         if(Boolean(onUpdateParams))
         {
            returnStr += ", onUpdateParams:" + String(onUpdateParams);
         }
         if(Boolean(onCompleteParams))
         {
            returnStr += ", onCompleteParams:" + String(onCompleteParams);
         }
         if(Boolean(onOverwriteParams))
         {
            returnStr += ", onOverwriteParams:" + String(onOverwriteParams);
         }
         if(rounded)
         {
            returnStr += ", rounded:" + String(rounded);
         }
         if(isPaused)
         {
            returnStr += ", isPaused:" + String(isPaused);
         }
         if(Boolean(timePaused))
         {
            returnStr += ", timePaused:" + String(timePaused);
         }
         if(isCaller)
         {
            returnStr += ", isCaller:" + String(isCaller);
         }
         if(Boolean(count))
         {
            returnStr += ", count:" + String(count);
         }
         if(Boolean(timesCalled))
         {
            returnStr += ", timesCalled:" + String(timesCalled);
         }
         if(waitFrames)
         {
            returnStr += ", waitFrames:" + String(waitFrames);
         }
         if(hasStarted)
         {
            returnStr += ", hasStarted:" + String(hasStarted);
         }
         return returnStr + "]\n";
      }
   }
}

