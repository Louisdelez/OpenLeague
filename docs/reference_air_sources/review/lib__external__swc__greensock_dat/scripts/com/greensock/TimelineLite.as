package com.greensock
{
   import com.greensock.core.*;
   
   public class TimelineLite extends SimpleTimeline
   {
      
      public static const version:Number = 1.695;
      
      private static var _overwriteMode:int = OverwriteManager.enabled ? OverwriteManager.mode : OverwriteManager.init(2);
      
      protected var _endCaps:Array;
      
      protected var _labels:Object;
      
      public function TimelineLite(vars:Object = null)
      {
         super(vars);
         _endCaps = [null,null];
         _labels = {};
         this.autoRemoveChildren = Boolean(this.vars.autoRemoveChildren == true);
         _hasUpdate = Boolean(typeof this.vars.onUpdate == "function");
         if(this.vars.tweens is Array)
         {
            this.insertMultiple(this.vars.tweens,0,this.vars.align != null ? this.vars.align : "normal",Boolean(this.vars.stagger) ? Number(this.vars.stagger) : 0);
         }
      }
      
      public function set timeScale(n:Number) : void
      {
         if(n == 0)
         {
            n = 0.0001;
         }
         var tlTime:Number = Boolean(this.cachedPauseTime) || this.cachedPauseTime == 0 ? this.cachedPauseTime : this.timeline.cachedTotalTime;
         this.cachedStartTime = tlTime - (tlTime - this.cachedStartTime) * this.cachedTimeScale / n;
         this.cachedTimeScale = n;
         setDirtyCache(false);
      }
      
      public function stop() : void
      {
         this.paused = true;
      }
      
      override public function renderTime(time:Number, suppressEvents:Boolean = false, force:Boolean = false) : void
      {
         var tween:TweenCore = null;
         var isComplete:Boolean = false;
         var rendered:Boolean = false;
         var next:TweenCore = null;
         var dur:Number = NaN;
         if(this.gc)
         {
            this.setEnabled(true,false);
         }
         else if(!this.active && !this.cachedPaused)
         {
            this.active = true;
         }
         var totalDur:Number = this.cacheIsDirty ? this.totalDuration : this.cachedTotalDuration;
         var prevTime:Number = this.cachedTime;
         var prevStart:Number = this.cachedStartTime;
         var prevTimeScale:Number = this.cachedTimeScale;
         var prevPaused:Boolean = this.cachedPaused;
         if(time >= totalDur)
         {
            if(prevTime != totalDur && _rawPrevTime != time)
            {
               this.cachedTotalTime = this.cachedTime = totalDur;
               forceChildrenToEnd(totalDur,suppressEvents);
               isComplete = !this.hasPausedChild() && !this.cachedReversed;
               rendered = true;
               if(this.cachedDuration == 0 && isComplete && (time == 0 || _rawPrevTime < 0))
               {
                  force = true;
               }
            }
         }
         else if(time <= 0)
         {
            if(time < 0)
            {
               this.active = false;
               if(this.cachedDuration == 0 && _rawPrevTime > 0)
               {
                  force = true;
                  isComplete = true;
               }
            }
            else if(time == 0 && !this.initted)
            {
               force = true;
            }
            if(prevTime != 0 && _rawPrevTime != time)
            {
               this.cachedTotalTime = 0;
               this.cachedTime = 0;
               forceChildrenToBeginning(0,suppressEvents);
               rendered = true;
               if(this.cachedReversed)
               {
                  isComplete = true;
               }
            }
         }
         else
         {
            this.cachedTotalTime = this.cachedTime = time;
         }
         _rawPrevTime = time;
         if(this.cachedTime == prevTime && !force)
         {
            return;
         }
         if(!this.initted)
         {
            this.initted = true;
         }
         if(Boolean(prevTime == 0 && this.vars.onStart) && Boolean(this.cachedTime != 0) && !suppressEvents)
         {
            this.vars.onStart.apply(null,this.vars.onStartParams);
         }
         if(!rendered)
         {
            if(this.cachedTime - prevTime > 0)
            {
               tween = _firstChild;
               while(Boolean(tween))
               {
                  next = tween.nextNode;
                  if(this.cachedPaused && !prevPaused)
                  {
                     break;
                  }
                  if(tween.active || !tween.cachedPaused && tween.cachedStartTime <= this.cachedTime && !tween.gc)
                  {
                     if(!tween.cachedReversed)
                     {
                        tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                     else
                     {
                        dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration;
                        tween.renderTime(dur - (this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                  }
                  tween = next;
               }
            }
            else
            {
               tween = _lastChild;
               while(Boolean(tween))
               {
                  next = tween.prevNode;
                  if(this.cachedPaused && !prevPaused)
                  {
                     break;
                  }
                  if(tween.active || !tween.cachedPaused && tween.cachedStartTime <= prevTime && !tween.gc)
                  {
                     if(!tween.cachedReversed)
                     {
                        tween.renderTime((this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                     else
                     {
                        dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration;
                        tween.renderTime(dur - (this.cachedTime - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
                     }
                  }
                  tween = next;
               }
            }
         }
         if(_hasUpdate && !suppressEvents)
         {
            this.vars.onUpdate.apply(null,this.vars.onUpdateParams);
         }
         if(isComplete && (prevStart == this.cachedStartTime || prevTimeScale != this.cachedTimeScale) && (totalDur >= this.totalDuration || this.cachedTime == 0))
         {
            complete(true,suppressEvents);
         }
      }
      
      override public function remove(tween:TweenCore, skipDisable:Boolean = false) : void
      {
         if(tween.cachedOrphan)
         {
            return;
         }
         if(!skipDisable)
         {
            tween.setEnabled(false,true);
         }
         var first:TweenCore = this.gc ? _endCaps[0] : _firstChild;
         var last:TweenCore = this.gc ? _endCaps[1] : _lastChild;
         if(Boolean(tween.nextNode))
         {
            tween.nextNode.prevNode = tween.prevNode;
         }
         else if(last == tween)
         {
            last = tween.prevNode;
         }
         if(Boolean(tween.prevNode))
         {
            tween.prevNode.nextNode = tween.nextNode;
         }
         else if(first == tween)
         {
            first = tween.nextNode;
         }
         if(this.gc)
         {
            _endCaps[0] = first;
            _endCaps[1] = last;
         }
         else
         {
            _firstChild = first;
            _lastChild = last;
         }
         tween.cachedOrphan = true;
         setDirtyCache(true);
      }
      
      public function get currentProgress() : Number
      {
         return this.cachedTime / this.duration;
      }
      
      override public function get totalDuration() : Number
      {
         var max:Number = NaN;
         var end:Number = NaN;
         var tween:TweenCore = null;
         var prevStart:Number = NaN;
         var next:TweenCore = null;
         if(this.cacheIsDirty)
         {
            max = 0;
            tween = this.gc ? _endCaps[0] : _firstChild;
            prevStart = -Infinity;
            while(Boolean(tween))
            {
               next = tween.nextNode;
               if(tween.cachedStartTime < prevStart)
               {
                  this.insert(tween,tween.cachedStartTime - tween.delay);
               }
               else
               {
                  prevStart = tween.cachedStartTime;
               }
               if(tween.cachedStartTime < 0)
               {
                  max -= tween.cachedStartTime;
                  this.shiftChildren(-tween.cachedStartTime,false,-9999999999);
               }
               end = tween.cachedStartTime + tween.totalDuration / tween.cachedTimeScale;
               if(end > max)
               {
                  max = end;
               }
               tween = next;
            }
            this.cachedDuration = this.cachedTotalDuration = max;
            this.cacheIsDirty = false;
         }
         return this.cachedTotalDuration;
      }
      
      public function gotoAndPlay(timeOrLabel:*, suppressEvents:Boolean = true) : void
      {
         setTotalTime(parseTimeOrLabel(timeOrLabel),suppressEvents);
         play();
      }
      
      public function appendMultiple(tweens:Array, offset:Number = 0, align:String = "normal", stagger:Number = 0) : Array
      {
         return insertMultiple(tweens,this.duration + offset,align,stagger);
      }
      
      public function set currentProgress(n:Number) : void
      {
         setTotalTime(this.duration * n,false);
      }
      
      public function clear(tweens:Array = null) : void
      {
         if(tweens == null)
         {
            tweens = getChildren(false,true,true);
         }
         var i:int = int(tweens.length);
         while(--i > -1)
         {
            TweenCore(tweens[i]).setEnabled(false,false);
         }
      }
      
      public function prepend(tween:TweenCore, adjustLabels:Boolean = false) : TweenCore
      {
         shiftChildren(tween.totalDuration / tween.cachedTimeScale + tween.delay,adjustLabels,0);
         return insert(tween,0);
      }
      
      public function removeLabel(label:String) : Number
      {
         var n:Number = Number(_labels[label]);
         delete _labels[label];
         return n;
      }
      
      protected function parseTimeOrLabel(timeOrLabel:*) : Number
      {
         if(typeof timeOrLabel == "string")
         {
            if(!(timeOrLabel in _labels))
            {
               throw new Error("TimelineLite error: the " + timeOrLabel + " label was not found.");
            }
            return getLabelTime(String(timeOrLabel));
         }
         return Number(timeOrLabel);
      }
      
      public function addLabel(label:String, time:Number) : void
      {
         _labels[label] = time;
      }
      
      public function hasPausedChild() : Boolean
      {
         var tween:TweenCore = this.gc ? _endCaps[0] : _firstChild;
         while(Boolean(tween))
         {
            if(tween.cachedPaused || tween is TimelineLite && (tween as TimelineLite).hasPausedChild())
            {
               return true;
            }
            tween = tween.nextNode;
         }
         return false;
      }
      
      public function getTweensOf(target:Object, nested:Boolean = true) : Array
      {
         var i:int = 0;
         var tweens:Array = getChildren(nested,true,false);
         var a:Array = [];
         var l:int = int(tweens.length);
         var cnt:int = 0;
         for(i = 0; i < l; i += 1)
         {
            if(TweenLite(tweens[i]).target == target)
            {
               a[cnt++] = tweens[i];
            }
         }
         return a;
      }
      
      public function gotoAndStop(timeOrLabel:*, suppressEvents:Boolean = true) : void
      {
         setTotalTime(parseTimeOrLabel(timeOrLabel),suppressEvents);
         this.paused = true;
      }
      
      public function append(tween:TweenCore, offset:Number = 0) : TweenCore
      {
         return insert(tween,this.duration + offset);
      }
      
      override public function get duration() : Number
      {
         var d:Number = NaN;
         if(this.cacheIsDirty)
         {
            d = this.totalDuration;
         }
         return this.cachedDuration;
      }
      
      public function get useFrames() : Boolean
      {
         var tl:SimpleTimeline = this.timeline;
         while(Boolean(tl.timeline))
         {
            tl = tl.timeline;
         }
         return Boolean(tl == TweenLite.rootFramesTimeline);
      }
      
      public function shiftChildren(amount:Number, adjustLabels:Boolean = false, ignoreBeforeTime:Number = 0) : void
      {
         var p:String = null;
         var tween:TweenCore = this.gc ? _endCaps[0] : _firstChild;
         while(Boolean(tween))
         {
            if(tween.cachedStartTime >= ignoreBeforeTime)
            {
               tween.cachedStartTime += amount;
            }
            tween = tween.nextNode;
         }
         if(adjustLabels)
         {
            for(p in _labels)
            {
               if(_labels[p] >= ignoreBeforeTime)
               {
                  _labels[p] += amount;
               }
            }
         }
         this.setDirtyCache(true);
      }
      
      public function goto(timeOrLabel:*, suppressEvents:Boolean = true) : void
      {
         setTotalTime(parseTimeOrLabel(timeOrLabel),suppressEvents);
      }
      
      public function killTweensOf(target:Object, nested:Boolean = true, vars:Object = null) : Boolean
      {
         var tween:TweenLite = null;
         var tweens:Array = getTweensOf(target,nested);
         var i:int = int(tweens.length);
         while(--i > -1)
         {
            tween = tweens[i];
            if(vars != null)
            {
               tween.killVars(vars);
            }
            if(vars == null || tween.cachedPT1 == null && tween.initted)
            {
               tween.setEnabled(false,false);
            }
         }
         return Boolean(tweens.length > 0);
      }
      
      override public function set duration(n:Number) : void
      {
         if(this.duration != 0 && n != 0)
         {
            this.timeScale = this.duration / n;
         }
      }
      
      public function insertMultiple(tweens:Array, timeOrLabel:* = 0, align:String = "normal", stagger:Number = 0) : Array
      {
         var i:int = 0;
         var tween:TweenCore = null;
         var curTime:Number = Number(Number(timeOrLabel) || 0);
         var l:int = int(tweens.length);
         if(typeof timeOrLabel == "string")
         {
            if(!(timeOrLabel in _labels))
            {
               addLabel(timeOrLabel,this.duration);
            }
            curTime = Number(_labels[timeOrLabel]);
         }
         for(i = 0; i < l; i += 1)
         {
            tween = tweens[i] as TweenCore;
            insert(tween,curTime);
            if(align == "sequence")
            {
               curTime = tween.cachedStartTime + tween.totalDuration / tween.cachedTimeScale;
            }
            else if(align == "start")
            {
               tween.cachedStartTime -= tween.delay;
            }
            curTime += stagger;
         }
         return tweens;
      }
      
      public function getLabelTime(label:String) : Number
      {
         return label in _labels ? Number(_labels[label]) : -1;
      }
      
      override public function get rawTime() : Number
      {
         if(this.cachedPaused || this.cachedTotalTime != 0 && this.cachedTotalTime != this.cachedTotalDuration)
         {
            return this.cachedTotalTime;
         }
         return (this.timeline.rawTime - this.cachedStartTime) * this.cachedTimeScale;
      }
      
      override public function set totalDuration(n:Number) : void
      {
         if(this.totalDuration != 0 && n != 0)
         {
            this.timeScale = this.totalDuration / n;
         }
      }
      
      public function getChildren(nested:Boolean = true, tweens:Boolean = true, timelines:Boolean = true, ignoreBeforeTime:Number = -9999999999) : Array
      {
         var a:Array = [];
         var cnt:int = 0;
         var tween:TweenCore = this.gc ? _endCaps[0] : _firstChild;
         while(Boolean(tween))
         {
            if(tween.cachedStartTime >= ignoreBeforeTime)
            {
               if(tween is TweenLite)
               {
                  if(tweens)
                  {
                     a[cnt++] = tween;
                  }
               }
               else
               {
                  if(timelines)
                  {
                     a[cnt++] = tween;
                  }
                  if(nested)
                  {
                     a = a.concat(TimelineLite(tween).getChildren(true,tweens,timelines));
                     cnt = int(a.length);
                  }
               }
            }
            tween = tween.nextNode;
         }
         return a;
      }
      
      protected function forceChildrenToEnd(time:Number, suppressEvents:Boolean = false) : Number
      {
         var next:TweenCore = null;
         var dur:Number = NaN;
         var tween:TweenCore = _firstChild;
         var prevPaused:Boolean = this.cachedPaused;
         while(Boolean(tween))
         {
            next = tween.nextNode;
            if(this.cachedPaused && !prevPaused)
            {
               break;
            }
            if(tween.active || !tween.cachedPaused && !tween.gc && (tween.cachedTotalTime != tween.cachedTotalDuration || tween.cachedDuration == 0))
            {
               if(time == this.cachedDuration && (tween.cachedDuration != 0 || tween.cachedStartTime == this.cachedDuration))
               {
                  tween.renderTime(tween.cachedReversed ? 0 : tween.cachedTotalDuration,suppressEvents,false);
               }
               else if(!tween.cachedReversed)
               {
                  tween.renderTime((time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
               else
               {
                  dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration;
                  tween.renderTime(dur - (time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
            }
            tween = next;
         }
         return time;
      }
      
      protected function forceChildrenToBeginning(time:Number, suppressEvents:Boolean = false) : Number
      {
         var next:TweenCore = null;
         var dur:Number = NaN;
         var tween:TweenCore = _lastChild;
         var prevPaused:Boolean = this.cachedPaused;
         while(Boolean(tween))
         {
            next = tween.prevNode;
            if(this.cachedPaused && !prevPaused)
            {
               break;
            }
            if(tween.active || !tween.cachedPaused && !tween.gc && (tween.cachedTotalTime != 0 || tween.cachedDuration == 0))
            {
               if(time == 0 && (tween.cachedDuration != 0 || tween.cachedStartTime == 0))
               {
                  tween.renderTime(tween.cachedReversed ? tween.cachedTotalDuration : 0,suppressEvents,false);
               }
               else if(!tween.cachedReversed)
               {
                  tween.renderTime((time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
               else
               {
                  dur = tween.cacheIsDirty ? tween.totalDuration : tween.cachedTotalDuration;
                  tween.renderTime(dur - (time - tween.cachedStartTime) * tween.cachedTimeScale,suppressEvents,false);
               }
            }
            tween = next;
         }
         return time;
      }
      
      override public function insert(tween:TweenCore, timeOrLabel:* = 0) : TweenCore
      {
         var curTween:TweenCore = null;
         var st:Number = NaN;
         var tl:SimpleTimeline = null;
         if(typeof timeOrLabel == "string")
         {
            if(!(timeOrLabel in _labels))
            {
               addLabel(timeOrLabel,this.duration);
            }
            timeOrLabel = Number(_labels[timeOrLabel]);
         }
         var prevTimeline:SimpleTimeline = tween.timeline;
         if(!tween.cachedOrphan && Boolean(prevTimeline))
         {
            prevTimeline.remove(tween,true);
         }
         tween.timeline = this;
         tween.cachedStartTime = Number(timeOrLabel) + tween.delay;
         if(tween.cachedPaused && prevTimeline != this)
         {
            tween.cachedPauseTime = tween.cachedStartTime + (this.rawTime - tween.cachedStartTime) / tween.cachedTimeScale;
         }
         if(tween.gc)
         {
            tween.setEnabled(true,true);
         }
         setDirtyCache(true);
         var first:TweenCore = this.gc ? _endCaps[0] : _firstChild;
         var last:TweenCore = this.gc ? _endCaps[1] : _lastChild;
         if(last == null)
         {
            first = last = tween;
            tween.nextNode = tween.prevNode = null;
         }
         else
         {
            curTween = last;
            st = tween.cachedStartTime;
            while(curTween != null && st < curTween.cachedStartTime)
            {
               curTween = curTween.prevNode;
            }
            if(curTween == null)
            {
               first.prevNode = tween;
               tween.nextNode = first;
               tween.prevNode = null;
               first = tween;
            }
            else
            {
               if(Boolean(curTween.nextNode))
               {
                  curTween.nextNode.prevNode = tween;
               }
               else if(curTween == last)
               {
                  last = tween;
               }
               tween.prevNode = curTween;
               tween.nextNode = curTween.nextNode;
               curTween.nextNode = tween;
            }
         }
         tween.cachedOrphan = false;
         if(this.gc)
         {
            _endCaps[0] = first;
            _endCaps[1] = last;
         }
         else
         {
            _firstChild = first;
            _lastChild = last;
         }
         if(this.gc && !this.cachedPaused && this.cachedStartTime + (tween.cachedStartTime + tween.cachedTotalDuration / tween.cachedTimeScale) / this.cachedTimeScale > this.timeline.cachedTime)
         {
            if(this.timeline == TweenLite.rootTimeline || this.timeline == TweenLite.rootFramesTimeline)
            {
               this.setTotalTime(this.cachedTotalTime,true);
            }
            this.setEnabled(true,false);
            tl = this.timeline;
            while(tl.gc && Boolean(tl.timeline))
            {
               if(tl.cachedStartTime + tl.totalDuration / tl.cachedTimeScale > tl.timeline.cachedTime)
               {
                  tl.setEnabled(true,false);
               }
               tl = tl.timeline;
            }
         }
         return tween;
      }
      
      override public function invalidate() : void
      {
         var tween:TweenCore = this.gc ? _endCaps[0] : _firstChild;
         while(Boolean(tween))
         {
            tween.invalidate();
            tween = tween.nextNode;
         }
      }
      
      public function get timeScale() : Number
      {
         return this.cachedTimeScale;
      }
      
      public function prependMultiple(tweens:Array, align:String = "normal", stagger:Number = 0, adjustLabels:Boolean = false) : Array
      {
         var tl:TimelineLite = new TimelineLite({
            "tweens":tweens,
            "align":align,
            "stagger":stagger
         });
         shiftChildren(tl.duration,adjustLabels,0);
         insertMultiple(tweens,0,align,stagger);
         tl.kill();
         return tweens;
      }
      
      override public function setEnabled(enabled:Boolean, ignoreTimeline:Boolean = false) : Boolean
      {
         var tween:TweenCore = null;
         if(enabled == this.gc)
         {
            if(enabled)
            {
               _firstChild = tween = _endCaps[0];
               _lastChild = _endCaps[1];
               _endCaps = [null,null];
            }
            else
            {
               tween = _firstChild;
               _endCaps = [_firstChild,_lastChild];
               _firstChild = _lastChild = null;
            }
            while(Boolean(tween))
            {
               tween.setEnabled(enabled,true);
               tween = tween.nextNode;
            }
         }
         return super.setEnabled(enabled,ignoreTimeline);
      }
   }
}

