package com.riotgames.pvpnet.tracker
{
   import blix.logger.LogLevelsEnum;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.pvpnet.tracker.parts.DataChangedEvent;
   import com.riotgames.pvpnet.tracker.parts.IClock;
   import com.riotgames.pvpnet.tracker.parts.NamedValue;
   import com.riotgames.pvpnet.tracker.parts.Recorder;
   import com.riotgames.pvpnet.tracker.parts.TrackerClock;
   import flash.events.EventDispatcher;
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class Tracker extends EventDispatcher implements ITracker, ITreeOfTrackers
   {
      
      public static var metricsProvider:IMetricsSubmitter;
      
      private static const REG:* = registerClassAlias("com.riotgames.pvpnet.tracker.Tracker",Tracker);
      
      protected static const MS_IN_HOURS:Number = 3600000;
      
      protected static const MS_IN_MINUTE:Number = 60000;
      
      public static const TRACKER_VERSION_NUMBER:String = "4.12.12";
      
      public static var clock:IClock = new TrackerClock();
      
      public var id:Number = -1;
      
      public var resumesOnRestart:Boolean;
      
      public var duration:Number = NaN;
      
      public var depthInHierarchy:int = 0;
      
      public var counters:Dictionary;
      
      public var recordings:Dictionary;
      
      public var data:Object = {};
      
      protected var _parentLine:ITreeOfTrackers;
      
      protected var spacer:String = "";
      
      protected var _canBeSent:Boolean;
      
      private var children:Array = [];
      
      protected var isLocked:Boolean;
      
      protected var forceSend:Boolean = false;
      
      protected var _lastChildAdded:ITracker;
      
      protected var _sent:Signal = new Signal();
      
      protected var _started:Signal = new Signal();
      
      protected var _stopped:Signal = new Signal();
      
      private var _name:String = "";
      
      private var isCalculatedFromChildren:Boolean = false;
      
      private var _isTimer:Boolean = true;
      
      private var _allowNegativeCalculation:Boolean = false;
      
      private var _allowMonthLongerCalculation:Boolean = false;
      
      protected var _startPoint:NamedValue = null;
      
      protected var _endPoint:NamedValue = null;
      
      protected var _hasStarted:Boolean;
      
      protected var _hasStopped:Boolean;
      
      protected var _isRunning:Boolean;
      
      protected var _hasBeenSent:Boolean;
      
      public function Tracker(param1:String, param2:Boolean = false, param3:Number = NaN, param4:Number = NaN, param5:Number = NaN)
      {
         super();
         this.init(param1,param2,param3,param4,param5);
      }
      
      public function get isTimer() : Boolean
      {
         return this._isTimer;
      }
      
      public function set isTimer(param1:Boolean) : void
      {
         if(this.isLocked)
         {
            return;
         }
         this._isTimer = param1;
      }
      
      public function get allowNegativeCalculation() : Boolean
      {
         return this._allowNegativeCalculation;
      }
      
      public function set allowNegativeCalculation(param1:Boolean) : void
      {
         this._allowNegativeCalculation = param1;
      }
      
      public function get allowMonthLongerCalculation() : Boolean
      {
         return this._allowMonthLongerCalculation;
      }
      
      public function set allowMonthLongerCalculation(param1:Boolean) : void
      {
         this._allowMonthLongerCalculation = param1;
      }
      
      public function get startPoint() : NamedValue
      {
         return this._startPoint;
      }
      
      public function set startPoint(param1:NamedValue) : void
      {
         if(this._startPoint != null)
         {
            this._startPoint.removeEventListener(DataChangedEvent.DATA_CHANGED,this.onStartPointChanged);
         }
         var _loc2_:DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGED);
         _loc2_.oldVal = this._startPoint;
         _loc2_.currentVal = param1;
         this._startPoint = param1;
         if(this._startPoint != null)
         {
            this._startPoint.addEventListener(DataChangedEvent.DATA_CHANGED,this.onStartPointChanged);
         }
         dispatchEvent(_loc2_);
      }
      
      public function get endPoint() : NamedValue
      {
         return this._endPoint;
      }
      
      public function set endPoint(param1:NamedValue) : void
      {
         if(this._endPoint != null)
         {
            this._endPoint.removeEventListener(DataChangedEvent.DATA_CHANGED,this.onEndPointChanged);
         }
         var _loc2_:DataChangedEvent = new DataChangedEvent(DataChangedEvent.DATA_CHANGED);
         _loc2_.oldVal = this._endPoint;
         _loc2_.currentVal = param1;
         this._endPoint = param1;
         if(this._endPoint != null)
         {
            this._endPoint.addEventListener(DataChangedEvent.DATA_CHANGED,this.onEndPointChanged);
         }
         dispatchEvent(_loc2_);
      }
      
      public function get hasStarted() : Boolean
      {
         var _loc1_:Tracker = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.isCalculatedFromChildren && this.children.length > 0)
         {
            _loc2_ = 0;
            _loc3_ = int(this.children.length);
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this.children[_loc2_] as Tracker;
               if(_loc1_.hasStarted)
               {
                  return true;
               }
               _loc2_++;
            }
            return false;
         }
         return this._hasStarted;
      }
      
      public function set hasStarted(param1:Boolean) : void
      {
         if(!(this.isCalculatedFromChildren && this.children.length > 0))
         {
            this._hasStarted = param1;
         }
      }
      
      public function get hasStopped() : Boolean
      {
         var _loc1_:Tracker = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.isCalculatedFromChildren && this.children.length > 0)
         {
            _loc2_ = 0;
            _loc3_ = int(this.children.length);
            while(_loc2_ < _loc3_)
            {
               _loc1_ = this.children[_loc2_] as Tracker;
               if(_loc1_.hasStopped)
               {
                  return true;
               }
               _loc2_++;
            }
            return false;
         }
         return this._hasStopped;
      }
      
      public function set hasStopped(param1:Boolean) : void
      {
         if(this.isLocked)
         {
            return;
         }
         if(!(this.isCalculatedFromChildren && this.children.length > 0))
         {
            this._hasStopped = param1;
         }
      }
      
      public function get isRunning() : Boolean
      {
         return this._isRunning;
      }
      
      public function set isRunning(param1:Boolean) : void
      {
         if(this.isLocked)
         {
            return;
         }
         this._isRunning = param1;
      }
      
      public function get hasBeenSent() : Boolean
      {
         return this._hasBeenSent;
      }
      
      public function set hasBeenSent(param1:Boolean) : void
      {
         this._hasBeenSent = param1;
      }
      
      override public function toString() : String
      {
         var _loc3_:String = null;
         var _loc1_:Object = this.flattenToVars();
         var _loc2_:Array = new Array();
         for(_loc3_ in _loc1_)
         {
            _loc2_.push(" " + _loc3_ + " = " + _loc1_[_loc3_]);
         }
         _loc2_.sort();
         _loc2_.reverse();
         return _loc2_.join("\r");
      }
      
      public function init(param1:String, param2:Boolean = false, param3:Number = NaN, param4:Number = NaN, param5:Number = NaN) : void
      {
         var name:String = param1;
         var resumesOnRestart:Boolean = param2;
         var start:Number = param3;
         var duration:Number = param4;
         var end:Number = param5;
         try
         {
            this.setDefaults();
            this.setName(name != null ? name : "");
            this.startPoint = new NamedValue("start_point",start);
            this.endPoint = new NamedValue("end_point",end);
            this.duration = duration;
            this.resumesOnRestart = resumesOnRestart;
            this.zero();
            this.counters = new Dictionary(true);
            this.recordings = new Dictionary(true);
            this.calc();
         }
         catch(er:Error)
         {
            sendTrackerError(_name,er);
         }
      }
      
      public function zero() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         try
         {
            this._startPoint.position = this._endPoint.position = 0;
         }
         catch(er:Error)
         {
            sendTrackerError(_name,er);
         }
         return this;
      }
      
      public function reset() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.setDefaults();
         this._startPoint.position = this.getNow();
         this._endPoint.position = this._startPoint.position;
         return this;
      }
      
      public function resetAll() : ITracker
      {
         var _loc3_:Tracker = null;
         if(this.isLocked)
         {
            return this;
         }
         var _loc1_:int = 0;
         var _loc2_:int = int(this.children.length);
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.children[_loc1_] as Tracker;
            _loc3_.reset();
            _loc1_++;
         }
         this.reset();
         return this;
      }
      
      public function getName() : String
      {
         return this._name;
      }
      
      public function setName(param1:String) : void
      {
         this._name = param1;
      }
      
      public function add(param1:String, param2:Boolean = false, param3:Number = NaN, param4:Number = NaN, param5:Number = NaN) : ITracker
      {
         var tt:Tracker = null;
         var timerName:String = param1;
         var resumesOnRestart:Boolean = param2;
         var start:Number = param3;
         var duration:Number = param4;
         var end:Number = param5;
         this.validateKey(timerName);
         try
         {
            tt = new Tracker(timerName,resumesOnRestart,start,duration,end);
            this.addChildTrackerToCollection(tt);
         }
         catch(er:Error)
         {
            tt = sendTrackerError(_name,er);
         }
         return tt;
      }
      
      public function get(param1:String, param2:Boolean = false) : ITracker
      {
         var res:ITracker;
         var i:int = 0;
         var n:int = 0;
         var c:ITracker = null;
         var timerName:String = param1;
         var createIfNotFound:Boolean = param2;
         this.validateKey(timerName);
         res = null;
         try
         {
            i = 0;
            n = int(this.children.length);
            while(i < n)
            {
               c = this.children[i] as ITracker;
               if(c.getName() == timerName)
               {
                  res = c;
                  break;
               }
               i++;
            }
            if(res == null)
            {
               if(createIfNotFound)
               {
                  res = this.add(timerName);
               }
               else
               {
                  res = this.sendTrackerError(timerName);
               }
            }
         }
         catch(er:Error)
         {
            res = sendTrackerError(_name,er);
         }
         return res;
      }
      
      public function has(param1:String) : Boolean
      {
         var res:ITracker;
         var i:int = 0;
         var n:int = 0;
         var c:ITracker = null;
         var timerName:String = param1;
         this.validateKey(timerName);
         res = null;
         try
         {
            i = 0;
            n = int(this.children.length);
            while(i < n)
            {
               c = this.children[i] as ITracker;
               if(c.getName() == timerName)
               {
                  res = c;
                  break;
               }
               i++;
            }
         }
         catch(er:Error)
         {
            sendTrackerError(_name,er);
         }
         return res != null;
      }
      
      public function removeChildByName(param1:String) : ITracker
      {
         var res:ITracker;
         var i:int = 0;
         var n:int = 0;
         var d:int = 0;
         var c:ITracker = null;
         var timerName:String = param1;
         if(this.isLocked)
         {
            return this;
         }
         res = null;
         try
         {
            i = 0;
            n = int(this.children.length);
            d = -1;
            while(i < n)
            {
               c = this.children[i] as ITracker;
               if(c.getName() == timerName)
               {
                  d = i;
                  break;
               }
               i++;
            }
            if(d >= 0)
            {
               this.children.splice(d,1);
            }
         }
         catch(er:Error)
         {
            res = sendTrackerError(_name,er);
         }
         return res;
      }
      
      public function remove(param1:Array) : ITracker
      {
         var i:int = 0;
         var n:int = 0;
         var d:int = 0;
         var aryOfChildNames:Array = param1;
         if(this.isLocked)
         {
            return this;
         }
         try
         {
            i = 0;
            n = int(aryOfChildNames.length);
            d = -1;
            while(i < n)
            {
               this.removeChildByName(aryOfChildNames[i]);
               i++;
            }
         }
         catch(er:Error)
         {
            sendTrackerError(_name,er);
         }
         return this;
      }
      
      public function removeAllChildren() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.children = [];
         return this;
      }
      
      public function lock() : ITracker
      {
         this.isLocked = true;
         return this;
      }
      
      public function unlock() : ITracker
      {
         this.isLocked = false;
         return this;
      }
      
      public function start() : ITracker
      {
         try
         {
            if(this.isLocked)
            {
               return this;
            }
            if(!this.isRunning)
            {
               if(this.resumesOnRestart && this._hasStarted)
               {
                  this._hasStarted = true;
                  this._started.dispatch(this);
                  this._endPoint.position = this.getNow();
                  this._startPoint.position = this._endPoint.position;
                  this.isRunning = true;
               }
               else if(!this.hasStarted)
               {
                  this._endPoint.position = this.getNow();
                  this._startPoint.position = this._endPoint.position;
                  this._hasStarted = true;
                  this.isRunning = true;
                  this._started.dispatch(this);
               }
            }
         }
         catch(er:Error)
         {
            sendTrackerError(_name,er);
         }
         return this;
      }
      
      public function startAll() : ITracker
      {
         var _loc3_:Tracker = null;
         if(this.isLocked)
         {
            return this;
         }
         this.start();
         var _loc1_:int = 0;
         var _loc2_:int = int(this.children.length);
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.children[_loc1_] as Tracker;
            _loc3_.start();
            _loc1_++;
         }
         return this;
      }
      
      public function resume() : ITracker
      {
         if(this.resumesOnRestart)
         {
            this.start();
         }
         return this;
      }
      
      public function stop() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         if(this.isRunning)
         {
            this.isRunning = false;
            this._endPoint.position = this.getNow();
            this._hasStopped = true;
            this.calc();
            this._stopped.dispatch(this);
         }
         return this;
      }
      
      public function stopAll() : ITracker
      {
         var _loc3_:Tracker = null;
         if(this.isLocked)
         {
            return this;
         }
         var _loc1_:int = 0;
         var _loc2_:int = int(this.children.length);
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.children[_loc1_] as Tracker;
            _loc3_.stop();
            _loc1_++;
         }
         this.stop();
         return this;
      }
      
      public function stopAndSend() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.stop();
         this.send();
         return this;
      }
      
      public function stopAndSendAll() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.stopAll();
         this.send();
         return this;
      }
      
      public function getNow() : Number
      {
         return clock.getNow();
      }
      
      public function getElapsedTimeInMS() : Number
      {
         var _loc1_:Number = NaN;
         if(this.isRunning)
         {
            this._endPoint.position = this.getNow();
            _loc1_ = this.duration;
         }
         else if(this.hasStarted && this.hasStopped)
         {
            _loc1_ = this.duration;
         }
         return _loc1_;
      }
      
      public function getElapsedTimeInHours() : Number
      {
         return this.getElapsedTimeInMS() / MS_IN_HOURS;
      }
      
      public function getElapsedTimeInMinutes() : Number
      {
         return this.getElapsedTimeInMS() / MS_IN_MINUTE;
      }
      
      public function updateSpacer() : void
      {
         var _loc1_:int = this.getDepthInHierarchy();
         var _loc2_:Array = new Array();
         while(Boolean(_loc1_--))
         {
            _loc2_.push("   ");
         }
         this.spacer = _loc2_.join("");
      }
      
      public function getFullQualifiedName() : String
      {
         var _loc1_:Array = new Array(this.getName());
         var _loc2_:ITreeOfTrackers = this._parentLine;
         while(_loc2_ != null)
         {
            _loc1_.unshift(_loc2_.getName());
            _loc2_ = (_loc2_ as ITracker).getParentTracker();
         }
         return _loc1_.join(".");
      }
      
      public function getDepthInHierarchy() : Number
      {
         if(this._parentLine != null)
         {
            return (this._parentLine as ITracker).getDepthInHierarchy() + 1;
         }
         return this.depthInHierarchy;
      }
      
      public function calc() : void
      {
         var _loc4_:NamedValue = null;
         if(this.isLocked)
         {
            return;
         }
         if(this.isCalculatedFromChildren && this.children.length > 0)
         {
            this.children.sort(this.order);
            this.startPoint = this.children[0].startPoint;
            this.endPoint = this.children[this.children.length - 1].endPoint;
         }
         var _loc1_:Boolean = this.startPoint != null && !isNaN(this.startPoint.position);
         var _loc2_:Boolean = this.endPoint != null && !isNaN(this.endPoint.position);
         var _loc3_:Boolean = !isNaN(this.duration);
         if(_loc1_ && _loc2_ && _loc3_ && this.resumesOnRestart)
         {
            if(this.isRunning)
            {
               this.stop();
               this.start();
               return;
            }
            this.duration += this.endPoint.position - this.startPoint.position;
            return;
         }
         if(!_loc1_ && _loc2_)
         {
            this.startPoint = new NamedValue("startPoint",this.endPoint.position - this.duration);
         }
         else if(_loc1_ && _loc2_)
         {
            this.duration = this.endPoint.position - this.startPoint.position;
            if(this.allowNegativeCalculation && this.duration < 0)
            {
               this.sendTrackerError(this._name,null,"INVALID_TRACKER_ERROR_NEGATIVE_DURATION");
            }
            else if(this.allowMonthLongerCalculation && 4 * 604800000 < this.duration)
            {
               this.sendTrackerError(this._name,null,"INVALID_TRACKER_ERROR_HUGE_DURATION");
            }
         }
         else if(_loc1_ && !_loc2_ && _loc3_)
         {
            _loc4_ = new NamedValue("endPoint",this.startPoint.position + this.duration);
            this.endPoint = _loc4_;
         }
      }
      
      public function shiftBy(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Dictionary = null;
         var _loc5_:Tracker = null;
         var _loc6_:NamedValue = null;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(this.isLocked)
         {
            return;
         }
         if(this.isCalculatedFromChildren && this.children.length > 0)
         {
            _loc2_ = 0;
            _loc3_ = int(this.children.length);
            _loc4_ = new Dictionary(true);
            while(_loc2_ < _loc3_)
            {
               _loc5_ = this.children[_loc2_] as Tracker;
               _loc4_[_loc5_.startPoint] = _loc5_.startPoint;
               _loc4_[_loc5_.endPoint] = _loc5_.endPoint;
               _loc2_++;
            }
            for each(_loc6_ in _loc4_)
            {
               _loc6_.dispatchEventsEnabled = false;
               _loc6_.position += param1;
               _loc6_.dispatchEventsEnabled = true;
            }
            this.calc();
         }
         else
         {
            _loc7_ = this.startPoint != null && !isNaN(this.startPoint.position);
            _loc8_ = this.endPoint != null && !isNaN(this.endPoint.position);
            if(_loc7_)
            {
               this.startPoint.position += param1;
            }
            if(_loc8_)
            {
               this.endPoint.position += param1;
            }
         }
      }
      
      public function resetAllToDefaults() : void
      {
         if(this.isLocked)
         {
            return;
         }
         this.clearAllProperties();
         this.clearAllCounters();
         this.clearAllRecordings();
         this.removeAllChildren();
         this.reset();
      }
      
      public function toJSON(param1:Boolean = true, param2:String = "", param3:Boolean = true) : *
      {
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Tracker = null;
         var _loc4_:String = "  ";
         var _loc5_:Vector.<String> = new Vector.<String>();
         var _loc6_:String = this.getFullQualifiedName();
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         if(param1)
         {
            _loc5_.push(param2);
         }
         if(this.children.length > 0 && param3)
         {
            _loc5_.push("[\r");
            if(param1)
            {
               _loc5_.push(param2);
            }
         }
         _loc5_.push("{\r");
         for(_loc9_ in this.data)
         {
            _loc7_ = true;
            if(param1)
            {
               _loc5_.push(param2 + "  ");
            }
            _loc5_.push("\"");
            _loc5_.push(_loc6_);
            _loc5_.push(".");
            _loc5_.push(_loc9_);
            _loc5_.push("\":\"");
            _loc5_.push(this.data[_loc9_]);
            if(this.isTimer)
            {
               _loc5_.push("\",\r");
            }
            else
            {
               _loc5_.push("\"\r");
            }
         }
         if(param1)
         {
            _loc5_.push(param2 + "  ");
         }
         this.hasBeenSent = true;
         if(this._isTimer)
         {
            _loc5_.push("\"");
            _loc5_.push(_loc6_);
            _loc5_.push(".");
            _loc5_.push("startTime\":\"");
            _loc5_.push(this.startPoint.position);
            _loc5_.push("\",\r");
            if(param1)
            {
               _loc5_.push(param2 + "  ");
            }
            _loc5_.push("\"");
            _loc5_.push(_loc6_);
            _loc5_.push(".");
            _loc5_.push("endTime\":\"");
            _loc5_.push(this.endPoint.position);
            _loc5_.push("\",\r");
            if(param1)
            {
               _loc5_.push(param2 + "  ");
            }
            this.getElapsedTimeInMS();
            _loc5_.push("\"");
            _loc5_.push(_loc6_);
            _loc5_.push(".");
            _loc5_.push("duration\":\"");
            _loc5_.push(this.duration);
            _loc5_.push("\"\r");
         }
         if(param1)
         {
            _loc5_.push(param2);
         }
         _loc5_.push("}");
         if(this.children.length > 0)
         {
            _loc8_ = true;
            _loc5_.push(",\r");
            _loc10_ = 0;
            _loc11_ = int(this.children.length);
            while(_loc10_ < _loc11_)
            {
               _loc12_ = this.children[_loc10_] as Tracker;
               if(param1 && _loc10_ != 0)
               {
                  _loc5_.push(param2);
               }
               _loc5_.push(_loc12_.toJSON(param1,param2,false));
               _loc12_.hasBeenSent = true;
               if(param1 && _loc10_ < _loc11_ - 1)
               {
                  _loc5_.push("\r");
               }
               _loc10_++;
            }
         }
         if(this.children.length > 0 && param3)
         {
            if(param1)
            {
               _loc5_.push("\r");
            }
            _loc5_.push("]");
         }
         return _loc5_.join("");
      }
      
      public function getFullName(param1:Boolean = false) : String
      {
         var _loc2_:Array = new Array();
         if(!param1)
         {
            _loc2_.push(this.getName());
            _loc2_.push(".");
         }
         var _loc3_:ITreeOfTrackers = this._parentLine;
         while(_loc3_ != null && (_loc3_ as ITracker).getParentTracker() != null)
         {
            _loc2_.unshift(".");
            _loc2_.unshift(_loc3_.getName());
            _loc3_ = (_loc3_ as ITracker).getParentTracker();
         }
         return _loc2_.join("");
      }
      
      public function flattenToVars(param1:Object = null) : Object
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc10_:Tracker = null;
         var _loc2_:Boolean = false;
         if(param1 == null)
         {
            param1 = new Object();
            _loc2_ = true;
         }
         var _loc3_:String = this.getFullName(_loc2_);
         var _loc4_:Object = null;
         for(_loc5_ in this.data)
         {
            _loc4_ = this.data[_loc5_];
            if(_loc4_ != null)
            {
               param1[_loc3_ + _loc5_] = _loc4_;
            }
         }
         for(_loc6_ in this.counters)
         {
            _loc4_ = this.counters[_loc6_];
            if(_loc4_ != null)
            {
               param1[_loc3_ + _loc6_] = _loc4_;
            }
         }
         for(_loc7_ in this.recordings)
         {
            (this.recordings[_loc7_] as Recorder).flattenToVars(param1);
         }
         if(this._isTimer && this.hasStarted)
         {
            param1[_loc3_ + "start_time"] = this.startPoint.position;
            param1[_loc3_ + "end_time"] = this.endPoint.position;
            param1[_loc3_ + "duration"] = this.duration;
         }
         var _loc8_:int = 0;
         var _loc9_:int = int(this.children.length);
         while(_loc8_ < _loc9_)
         {
            _loc10_ = this.children[_loc8_] as Tracker;
            _loc10_.flattenToVars(param1);
            _loc8_++;
         }
         return param1;
      }
      
      public function clone() : Object
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeObject(this);
         _loc1_.position = 0;
         return _loc1_.readObject();
      }
      
      public function getParentTracker() : ITreeOfTrackers
      {
         return this._parentLine;
      }
      
      public function setParentTracker(param1:ITreeOfTrackers) : void
      {
         if(this.isLocked)
         {
            return;
         }
         this._parentLine = param1;
      }
      
      public function setDirty() : ITracker
      {
         this._hasBeenSent = false;
         return this;
      }
      
      public function send() : ITracker
      {
         var _loc1_:Object = null;
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         if(this._canBeSent)
         {
            if(metricsProvider != null)
            {
               _loc1_ = this.flattenToVars();
               _loc2_ = false;
               var _loc4_:int = 0;
               var _loc5_:* = _loc1_;
               for(_loc3_ in _loc5_)
               {
                  _loc2_ = true;
                  _loc1_.tracker_version = TRACKER_VERSION_NUMBER;
               }
               if(_loc2_)
               {
                  metricsProvider.track(this.getName(),_loc1_,this.forceSend);
                  this.hasBeenSent = true;
                  this._sent.dispatch(this,this.toString());
               }
            }
         }
         return this;
      }
      
      public function clearAllProperties() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.data = {};
         return this;
      }
      
      public function getProperty(param1:String) : Object
      {
         return this.data[param1];
      }
      
      public function setProperty(param1:String, param2:Object = null) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         this.data[param1] = param2;
         return this;
      }
      
      public function addTimeStampedEvent(param1:String) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         this.data[param1] = this.getNow();
         return this;
      }
      
      public function clearAllCounters() : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.counters = new Dictionary(true);
         return this;
      }
      
      public function removeCounter(param1:String) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         delete this.counters[param1];
         return this;
      }
      
      public function incrementCounter(param1:String, param2:Number = 1, param3:Boolean = true) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         if(this.counters[param1] == null)
         {
            if(param3)
            {
               this.counters[param1] = 0;
               this.counters[param1] += param2;
            }
         }
         else
         {
            this.counters[param1] += param2;
         }
         return this;
      }
      
      public function decrementCounter(param1:String, param2:Number = 1, param3:Boolean = true) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         if(this.counters[param1] == null)
         {
            if(param3)
            {
               this.counters[param1] = 0;
               this.counters[param1] -= param2;
            }
         }
         else
         {
            this.counters[param1] -= param2;
         }
         return this;
      }
      
      public function setIfMaxCounter(param1:String, param2:Number, param3:Boolean = true) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         if(this.counters[param1] == null)
         {
            if(param3)
            {
               this.counters[param1] = param2;
            }
         }
         else if(this.counters[param1] < param2)
         {
            this.counters[param1] = param2;
         }
         return this;
      }
      
      public function setIfMinCounter(param1:String, param2:Number, param3:Boolean = true) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         if(this.counters[param1] == null)
         {
            if(param3)
            {
               this.counters[param1] = param2;
            }
         }
         else if(param2 < this.counters[param1])
         {
            this.counters[param1] = param2;
         }
         return this;
      }
      
      public function setCounterValue(param1:String, param2:Number = 0, param3:Boolean = true) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         if(this.counters[param1] == null)
         {
            if(param3)
            {
               this.counters[param1] = param2;
            }
         }
         else
         {
            this.counters[param1] = param2;
         }
         return this;
      }
      
      public function getCounterValue(param1:String) : Number
      {
         this.validateKey(param1);
         return this.counters[param1];
      }
      
      public function hasCounter(param1:String) : Boolean
      {
         this.validateKey(param1);
         return this.counters[param1] != null;
      }
      
      public function hasRecording(param1:String) : Boolean
      {
         this.validateKey(param1);
         return this.recordings[param1] != null;
      }
      
      public function getRecording(param1:String) : Recorder
      {
         this.validateKey(param1);
         return this.recordings[param1];
      }
      
      public function validateKey(param1:String) : void
      {
         if(param1 == null || param1 == "")
         {
            this.sendTrackerError(this.getName(),new Error("invalid record key name, cannot be null"));
         }
      }
      
      public function recordValue(param1:String, param2:Number = 0, param3:Boolean = true, param4:Boolean = true) : ITracker
      {
         var _loc5_:Recorder = null;
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         if(this.recordings[param1] == null)
         {
            if(param3)
            {
               _loc5_ = new Recorder(param1);
               this.recordings[param1] = _loc5_;
               _loc5_.includeTotalAndEntryCount = param4;
               _loc5_.parent = this;
               _loc5_.record(param2);
            }
         }
         else
         {
            (this.recordings[param1] as Recorder).record(param2);
         }
         return this;
      }
      
      public function clearAllRecordings() : ITracker
      {
         var _loc1_:String = null;
         if(this.isLocked)
         {
            return this;
         }
         for(_loc1_ in this.recordings)
         {
            (this.recordings[_loc1_] as Recorder).parent = null;
         }
         this.recordings = new Dictionary(true);
         return this;
      }
      
      public function removeRecording(param1:String) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         this.validateKey(param1);
         delete this.recordings[param1];
         return this;
      }
      
      public function addAndStartNewSegmentAndStopLast(param1:String) : ITracker
      {
         if(this.isLocked)
         {
            return this;
         }
         if(this._lastChildAdded != null)
         {
            this._lastChildAdded.stop();
         }
         this._lastChildAdded = this.add(param1) as ITracker;
         this._lastChildAdded.start();
         return this._lastChildAdded;
      }
      
      public function getSent() : ISignal
      {
         return this._sent;
      }
      
      public function getStopped() : ISignal
      {
         return this._stopped;
      }
      
      public function getStarted() : ISignal
      {
         return this._started;
      }
      
      public function addChildTrackerToCollection(param1:ITracker) : void
      {
         var tk:Tracker = null;
         var ch:ITracker = param1;
         if(this.isLocked)
         {
            return;
         }
         try
         {
            if(ch is Tracker)
            {
               tk = ch as Tracker;
               tk.setParentTracker(this);
               tk.updateSpacer();
            }
            this._lastChildAdded = ch;
            this.children.push(ch);
            this.calc();
         }
         catch(er:Error)
         {
            sendTrackerError(_name,er);
         }
      }
      
      protected function order(param1:Tracker, param2:Tracker) : Number
      {
         if(param1.startPoint.position < param2.startPoint.position)
         {
            return -1;
         }
         if(param1.startPoint.position > param2.startPoint.position)
         {
            return 1;
         }
         if(param1.startPoint.position == param2.startPoint.position)
         {
            if(param1.endPoint.position < param2.endPoint.position)
            {
               return -1;
            }
            if(param1.endPoint.position > param2.endPoint.position)
            {
               return 1;
            }
            return 0;
         }
         return 0;
      }
      
      protected function sendTrackerError(param1:String, param2:Error = null, param3:String = "INVALID_TRACKER_ERROR") : Tracker
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc4_:Tracker = new Tracker("logging_level.tracker" + LogLevelsEnum.ERROR);
         try
         {
            if(param2 == null)
            {
               param2 = new Error();
            }
            _loc5_ = param2.getStackTrace();
            _loc6_ = _loc5_.split("\n")[3];
            _loc4_.setProperty("error_type",param3);
            _loc4_.setProperty("tracker_name",param1);
            _loc4_.setProperty("caller",_loc6_);
            _loc4_.setProperty("stack_trace",_loc5_);
            _loc4_.setProperty(this.toString());
            this._canBeSent = false;
            _loc4_.send();
         }
         catch(er:Error)
         {
         }
         return _loc4_;
      }
      
      private function setDefaults() : void
      {
         this._hasStarted = false;
         this._hasStopped = false;
         this._isRunning = false;
         this._canBeSent = true;
         this._hasBeenSent = false;
         this.isLocked = false;
         this.duration = NaN;
      }
      
      public function onStartPointChanged(param1:DataChangedEvent) : void
      {
         if(this.isRunning)
         {
            this.calc();
         }
      }
      
      public function onEndPointChanged(param1:DataChangedEvent) : void
      {
         if(this.isRunning)
         {
            this.calc();
         }
      }
   }
}

