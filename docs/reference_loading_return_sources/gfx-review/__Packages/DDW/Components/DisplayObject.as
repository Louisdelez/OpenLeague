class DDW.Components.DisplayObject
{
   var _animationMetric;
   var _dragTarget;
   var _events;
   var _mask;
   var _redrawList;
   var blinkCount;
   var blinkStep;
   var blinkTransform;
   var cls;
   var graphics;
   var id;
   var layoutHash;
   var orgAlpha;
   var orgTransform;
   var parent;
   static var zeroBased = 0;
   static var DATA = "onData";
   static var KILL_FOCUS = "onKillFocus";
   static var LOAD = "onLoad";
   static var SET_FOCUS = "onSetFocus";
   static var UNLOAD = "onUnload";
   static var idCounter = 0;
   var name = "graphics";
   var _libraryName = "";
   var _class = "DisplayObject";
   var _needsRedraw = true;
   var _x = 0;
   var _y = 0;
   var _width = 0;
   var _height = 0;
   var _rotation = 0;
   var _xscale = 100;
   var _yscale = 100;
   var _alpha = 100;
   var _currentframe = 1;
   var _layer = 1;
   var _enabled = false;
   var _focusEnabled = false;
   var _visible = true;
   var _isCreated = false;
   var _isDragable = false;
   var _isPlaying = true;
   var _filters = [];
   var _baseEventsCreated = false;
   var attached = false;
   var _isDragging = false;
   var _isDisposing = false;
   var _wasDragging = false;
   var _hasDragListeners = false;
   var _startDragTimeout = false;
   var _dragTimeoutId = 0;
   var displayMode = DDW.Enums.DisplayMode.normal;
   var isStaticImage = false;
   var showImage = true;
   var eventAttachTimer = -1;
   var blinkIntervalID = -1;
   static var defaultBlinkCount = 10;
   static var defaultBlinkDuration = 320;
   var blinkContinuous = false;
   var maxBrightness = 100;
   var minBrightness = -100;
   function DisplayObject(libraryName, mx)
   {
      this.id = idCounter++;
      if(libraryName != null)
      {
         this.libraryName = libraryName;
      }
      this._redrawList = [];
      this._events = [];
      this.addEventListener(DDW.Events.Event.ADDED_TO_STAGE,this,this.addedToStage);
      this.addEventListener(DDW.Events.Event.REMOVED_FROM_STAGE,this,this.removedFromStage);
      if(mx != null)
      {
         this.x = mx.x;
         this.y = mx.y;
         this.width = mx.width;
         this.height = mx.height;
      }
   }
   function get libraryName()
   {
      return this._libraryName;
   }
   function set libraryName(value)
   {
      this._libraryName = value;
   }
   function get x()
   {
      return this._x;
   }
   function set x(value)
   {
      this._x = value;
      this._redrawList.push(["_x",this._x]);
      this.needsRedraw();
   }
   function get y()
   {
      return this._y;
   }
   function set y(value)
   {
      this._y = value;
      this._redrawList.push(["_y",this._y]);
      this.needsRedraw();
   }
   function get width()
   {
      return this._width;
   }
   function set width(value)
   {
      this._width = value;
      if(this.libraryName != "" && this._width != 0)
      {
         this._redrawList.push(["_width",this._width]);
         this.needsRedraw();
      }
   }
   function get height()
   {
      return this._height;
   }
   function set height(value)
   {
      this._height = value;
      if(this.libraryName != "" && this._height != 0)
      {
         this._redrawList.push(["_height",this._height]);
         this.needsRedraw();
      }
   }
   function get rotation()
   {
      return this._rotation;
   }
   function set rotation(value)
   {
      this._rotation = value;
      this._redrawList.push(["_rotation",this._rotation]);
      this.needsRedraw();
   }
   function get scaleX()
   {
      return this._xscale;
   }
   function set scaleX(value)
   {
      this._xscale = value;
      this._redrawList.push(["_xscale",this._xscale]);
      this.needsRedraw();
   }
   function get scaleY()
   {
      return this._yscale;
   }
   function set scaleY(value)
   {
      this._yscale = value;
      this._redrawList.push(["_yscale",this._yscale]);
      this.needsRedraw();
   }
   function get alpha()
   {
      return this._alpha;
   }
   function set alpha(value)
   {
      this._alpha = value;
      this._redrawList.push(["_alpha",this._alpha]);
      this.needsRedraw();
   }
   function get frame()
   {
      return this._currentframe;
   }
   function set frame(value)
   {
      this._currentframe = value;
      this.gotoAndStop(value);
   }
   function get layer()
   {
      return this._layer;
   }
   function get enabled()
   {
      return this._enabled;
   }
   function set enabled(value)
   {
      this._enabled = value;
      if(this.graphics != null)
      {
         this.graphics.enabled = value;
      }
   }
   function get focusEnabled()
   {
      return this._focusEnabled;
   }
   function set focusEnabled(value)
   {
      this._focusEnabled = value;
      if(this.graphics != null)
      {
         this.graphics.focusEnabled = value;
      }
   }
   function get visible()
   {
      return this._visible;
   }
   function set visible(value)
   {
      this._visible = value;
      if(this.graphics != null)
      {
         this.graphics._visible = value;
      }
      this._redrawList.push(["_visible",this._visible]);
      this.needsRedraw();
   }
   function get mask()
   {
      return this._mask;
   }
   function set mask(value)
   {
      this._mask = value;
      if(this.graphics != null)
      {
         this.graphics.setMask(value.graphics);
      }
   }
   function get filters()
   {
      return this._filters;
   }
   function set filters(value)
   {
      this._filters = value;
      if(this.graphics != null)
      {
         this.graphics.filters = value;
      }
      else
      {
         this._redrawList.push(["filters",this._filters]);
         this.needsRedraw();
      }
   }
   function get totalFrames()
   {
      var _loc2_ = -1;
      if(this.graphics != null)
      {
         _loc2_ = this.graphics._totalframes;
      }
      return _loc2_;
   }
   function get isPlaying()
   {
      return this._isPlaying;
   }
   function isDragging()
   {
      return this._isDragging;
   }
   function get isDragable()
   {
      return this._isDragable;
   }
   function set isDragable(value)
   {
      if(value && !this._isDragable)
      {
         this.addEventListener(DDW.Events.MouseEvent.PRESS,this,this.dragMouseDown);
      }
      else if(!value && this._isDragable)
      {
         this.removeEventListener(DDW.Events.MouseEvent.PRESS,this.dragMouseDown);
      }
      this._isDragable = value;
   }
   function get dragTarget()
   {
      return this._dragTarget;
   }
   function set dragTarget(value)
   {
      this._dragTarget = value;
   }
   function get animationMetric()
   {
      return this._animationMetric;
   }
   function set animationMetric(value)
   {
      this._animationMetric = value;
      this._animationMetric.start();
      this.needsRedraw();
   }
   function animateTo(dest, steps, callback, callbackTarg, callbackArg)
   {
      var _loc7_ = this.getMetrics();
      if(dest.propertyName != null)
      {
         _loc7_.propertyName = dest.propertyName;
         _loc7_.value = this[dest.propertyName];
      }
      this._animationMetric = new DDW.Utils.AnimationMetric(_loc7_,dest,steps,callback,callbackTarg,callbackArg);
      this._animationMetric.start();
      this.needsRedraw();
   }
   function animateValueTo(dest, steps, callback, callbackTarg, callbackArg)
   {
      this._animationMetric = new DDW.Utils.AnimationMetric(this.getValueMetrics(dest.propertyName),dest,steps,callback,callbackTarg,callbackArg);
      this._animationMetric.start();
      this.needsRedraw();
   }
   function addTo(parent)
   {
      var _loc3_;
      if(this.libraryName == "" || this.layoutHash.length > 0)
      {
         this.graphics = parent.graphics.createEmptyMovieClip("_" + this.id,this._layer);
      }
      else if(this.libraryName.indexOf("img://") == 0)
      {
         this.graphics = parent.graphics.createEmptyMovieClip("d_" + this.id,this._layer);
         this.graphics.cls = -1;
         _loc3_ = !DDW.Managers.GameManager.getInstance().isGfx ? this.libraryName.substring(6) : this.libraryName;
         loadMovie(_loc3_,this.graphics);
         this.redrawAll();
      }
      else
      {
         this.graphics = parent.graphics.attachMovie(this.libraryName,"_" + this.id,this._layer);
      }
   }
   function removeFrom(parent)
   {
      this.parent = null;
      if(this.graphics != null)
      {
         this.graphics.removeMovieClip();
      }
      this.parent = null;
      this.attached = false;
      this.graphics = null;
      this.dispatchEvent(DDW.Events.Event.REMOVED_FROM_STAGE);
   }
   function needsRedraw()
   {
      this._needsRedraw = true;
      if(this.parent != null)
      {
         this.parent.needsRedraw();
      }
   }
   function setDisplayMode(displayMode)
   {
      this.displayMode = displayMode;
      switch(displayMode)
      {
         case DDW.Enums.DisplayMode.normal:
            this.showImage = true;
            break;
         case DDW.Enums.DisplayMode.staticOnly:
            this.showImage = this.isStaticImage && this._visible;
            break;
         case DDW.Enums.DisplayMode.dynamicOnly:
            this.showImage = !this.isStaticImage && this._visible;
         default:
            return;
      }
   }
   function redraw()
   {
      var _loc2_ = false;
      var _loc3_;
      var _loc4_;
      if(this.graphics.cls == -1)
      {
         _loc2_ = true;
      }
      else if(this._needsRedraw && this.graphics != null)
      {
         _loc3_ = 0;
         while(_loc3_ < this._redrawList.length)
         {
            if(this.displayMode == DDW.Enums.DisplayMode.dynamicOnly && this._redrawList[_loc3_][0] == "_visible")
            {
               this._visible = this._redrawList[_loc3_][1];
               this.graphics._visible = !this.isStaticImage && this._visible;
            }
            else if(this.displayMode == DDW.Enums.DisplayMode.staticOnly && this._redrawList[_loc3_][0] == "_visible")
            {
               this._visible = this._redrawList[_loc3_][1];
               this.graphics._visible = this.showImage;
            }
            else
            {
               this[this._redrawList[_loc3_][0]] = this._redrawList[_loc3_][1];
               this.graphics[this._redrawList[_loc3_][0]] = this._redrawList[_loc3_][1];
            }
            if(this._redrawList[_loc3_][0] == "_width")
            {
               this._xscale = this.graphics._xscale;
            }
            else if(this._redrawList[_loc3_][0] == "_height")
            {
               this._yscale = this.graphics._yscale;
            }
            _loc3_ = _loc3_ + 1;
         }
         this._redrawList.splice(0);
         this.ensureListeners();
         _loc2_ = false;
         if(this._animationMetric != null)
         {
            _loc2_ = true;
            this._animationMetric.incrementT();
            _loc4_ = this._animationMetric.getCurrentMetric();
            if(!this._animationMetric.isComplete)
            {
               this.applyMetrics(_loc4_);
               _global.updateAfterEvent();
            }
            else
            {
               this.applyMetrics(_loc4_);
               this._animationMetric = null;
            }
         }
      }
      this._needsRedraw = _loc2_;
      return _loc2_;
   }
   function redrawAll()
   {
      this.scaleX = this._xscale;
      this.scaleY = this._yscale;
      this.x = this._x;
      this.y = this._y;
      this.rotation = this._rotation;
      this.alpha = this._alpha;
      var _loc2_ = this._visible;
      if(this.displayMode == DDW.Enums.DisplayMode.dynamicOnly)
      {
         _loc2_ = !this.isStaticImage && this._visible;
      }
      else if(this.displayMode == DDW.Enums.DisplayMode.staticOnly)
      {
         _loc2_ = this.showImage;
      }
      this.visible = _loc2_;
      if(this.graphics != null)
      {
         this.graphics._xscale = this._xscale;
         this.graphics._yscale = this._yscale;
         this.graphics._x = this._x;
         this.graphics._y = this._y;
         this.graphics._rotation = this._rotation;
         this.graphics._alpha = this._alpha;
         this.graphics._visible = _loc2_;
      }
   }
   function hitTest(x, y, shapeFlag, ignoreVisibleChildren)
   {
      var _loc6_ = false;
      if(this.graphics != null)
      {
         _loc6_ = this.graphics.hitTest(x,y,shapeFlag,ignoreVisibleChildren);
      }
      return _loc6_;
   }
   function setImage(imagePath)
   {
      this.libraryName = imagePath;
      var _loc3_;
      var _loc4_;
      if(this.parent != null)
      {
         this.removeBaseEvents();
         if(this.libraryName.indexOf("img://") != 0)
         {
            this.graphics = this.parent.graphics.createEmptyMovieClip(this.libraryName,this.layer);
         }
         else
         {
            _loc3_ = !DDW.Managers.GameManager.getInstance().isGfx ? this.libraryName.substring(6) : this.libraryName;
            _loc4_ = this.graphics.createEmptyMovieClip("imgClip",1);
            loadMovie(_loc3_,_loc4_);
         }
         this.addBaseEvents();
         _global.setTimeout(this.ensureListeners,200,this);
         this.redrawAll();
      }
   }
   function addEventListener(type, context, callback)
   {
      if(this._events[type] == null)
      {
         this._events[type] = [];
      }
      var _loc5_ = new DDW.Events.Event(type,this,context,callback);
      this._events[type].push(_loc5_);
      this.ensureClipListener(type,this._events[type]);
   }
   function removeEventListener(type, callback)
   {
      var _loc4_ = this._events[type];
      var _loc5_;
      var _loc6_;
      if(_loc4_ != null)
      {
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_.type == type && _loc6_.callback == callback)
            {
               _loc6_.callback = null;
               _loc4_.splice(_loc5_,1);
               this._events[type] = _loc4_;
               this.removeClipListener(type,_loc4_);
               break;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
      if(_loc4_.length == 0)
      {
         this.graphics[type] = null;
         this._events[type] = null;
      }
   }
   function ensureListeners(scope)
   {
      if(scope == null)
      {
         scope = this;
      }
      var _loc3_;
      var _loc4_;
      var _loc5_;
      if(scope.graphics != null && scope.graphics.cls == null)
      {
         scope.graphics.cls = scope;
         for(var type in scope._events)
         {
            _loc3_ = scope._events[type];
            if(_loc3_ != null && _loc3_.length > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  _loc4_ = _loc4_ + 1;
               }
               scope.graphics[type] = scope[type];
            }
         }
         if(scope.eventAttachTimer > -1)
         {
            _global.clearInterval(scope.eventAttachTimer);
            scope.eventAttachTimer = -1;
         }
         this.graphics._visible = this.visible;
         this.graphics._alpha = this.alpha;
         if(scope.mask != null)
         {
            scope.graphics.setMask(scope.mask.graphics);
         }
      }
      else if(scope.eventAttachTimer == -1)
      {
         scope.eventAttachTimer = _global.setInterval(scope.ensureListeners,200,scope);
      }
   }
   function ensureClipListener(type, events)
   {
      if(events != null && (events.length > 0 && this.graphics != null))
      {
         this.graphics[type] = this[type];
      }
   }
   function removeClipListener(type, events)
   {
      if(events != null && (events.length > 0 && this.graphics != null))
      {
         this.graphics[type] = null;
      }
   }
   function show()
   {
      if(this.parent != null)
      {
         this.visible = true;
         this.graphics._visible = true;
      }
   }
   function hide()
   {
      if(this.parent != null)
      {
         this.visible = false;
         this.graphics._visible = false;
      }
   }
   function gotoAndStop(frame)
   {
      this._currentframe = frame;
      this.isPlaying = false;
      if(this.graphics != null)
      {
         this.graphics.gotoAndStop(this._currentframe);
      }
   }
   function play()
   {
      this.isPlaying = true;
      if(this.graphics != null)
      {
         this.graphics.play();
      }
   }
   function stop()
   {
      this.isPlaying = false;
      if(this.graphics != null)
      {
         this.graphics.stop();
      }
   }
   function onAddedToStage()
   {
      this.cls.dispatchEvent(DDW.Events.Event.ADDED_TO_STAGE);
   }
   function onRemovedFromStage()
   {
      this.cls.dispatchEvent(DDW.Events.Event.REMOVED_FROM_STAGE);
   }
   function onRender()
   {
      this.cls.dispatchEvent(DDW.Events.Event.RENDER);
   }
   function onEnterFrame()
   {
      this.cls.dispatchEvent(DDW.Events.Event.ENTER_FRAME);
   }
   function onData()
   {
   }
   function onDragOut(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.DRAG_OUT,button,targetPath);
   }
   function onDragOver(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.DRAG_OVER,button,targetPath);
   }
   function onKeyDown()
   {
      this.cls.dispatchKeyboardEvent(DDW.Events.KeyboardEvent.KEY_DOWN);
   }
   function onKeyUp()
   {
      this.cls.dispatchKeyboardEvent(DDW.Events.KeyboardEvent.KEY_UP);
   }
   function onKillFocus()
   {
   }
   function onLoad()
   {
   }
   function onMouseDown(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.MOUSE_DOWN,button,targetPath);
   }
   function onMouseMove(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.MOUSE_MOVE,button,targetPath);
   }
   function onMouseUp(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.MOUSE_UP,button,targetPath);
   }
   function onPress(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.PRESS,button,targetPath);
   }
   function onRelease(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.RELEASE,button,targetPath);
   }
   function onReleaseOutside(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.RELEASE_OUTSIDE,button,targetPath);
   }
   function onRollOut(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.ROLL_OUT,button,targetPath);
   }
   function onRollOver(button, targetPath)
   {
      this.cls.dispatchMouseEvent(DDW.Events.MouseEvent.ROLL_OVER,button,targetPath);
   }
   function onSetFocus()
   {
   }
   function onUnload()
   {
   }
   function dragMouseDown(obj, e)
   {
      if(obj._isDragable && this.enabled)
      {
         this._wasDragging = false;
         if(!obj._isDragging)
         {
            if(this._dragTimeoutId != 0)
            {
               _global.clearTimeout(this._dragTimeoutId);
               this._dragTimeoutId = 0;
            }
            this._dragTimeoutId = _global.setTimeout(this.allowItemDrag,150,this);
            this._isDragging = false;
            this._hasDragListeners = true;
            this._startDragTimeout = false;
            obj.addEventListener(DDW.Events.MouseEvent.RELEASE_OUTSIDE,obj,this.dragMouseUp);
            obj.addEventListener(DDW.Events.MouseEvent.RELEASE,obj,this.dragMouseUpInside);
            DDW.Managers.GameManager.getInstance().cursor.addEventListener(DDW.Events.MouseEvent.MOUSE_MOVE,this,this.dragMouseMove);
            this.ensureListeners();
            DDW.Managers.GameManager.getInstance().cursor.visible = true;
            DDW.Managers.GameManager.getInstance().cursor.alpha = 0;
            DDW.Managers.GameManager.getInstance().cursor.setImage(this.libraryName);
            DDW.Managers.GameManager.getInstance().cursor.scaleX = 60;
            DDW.Managers.GameManager.getInstance().cursor.scaleY = 60;
         }
      }
   }
   function allowItemDrag(scope)
   {
      if(scope == null)
      {
         scope = this;
      }
      scope._dragTimeoutId = 0;
      scope._startDragTimeout = true;
      trace("allowItemDrag");
   }
   function dragMouseMove(obj, e)
   {
      trace("dragging");
      if(this._isDragging)
      {
         if(!this._wasDragging)
         {
            this.alpha = 35;
            DDW.Managers.GameManager.getInstance().cursor.alpha = 100;
         }
         this._wasDragging = true;
      }
      else if(this._startDragTimeout)
      {
         this._isDragging = true;
         this._wasDragging = false;
         DDW.Communication.Comm.send("ItemDragging","1");
      }
   }
   function dragMouseUp(obj, e)
   {
      if(this._isDragging)
      {
         DDW.Managers.GameManager.getInstance().cursor.visible = false;
         DDW.Managers.GameManager.getInstance().cursor.alpha = 0;
         this.alpha = 100;
         this.redrawAll();
         DDW.Communication.Comm.send("ItemDragging","0");
      }
      if(this._hasDragListeners)
      {
         obj.removeEventListener(DDW.Events.MouseEvent.RELEASE_OUTSIDE,this.dragMouseUp);
         obj.removeEventListener(DDW.Events.MouseEvent.RELEASE,this.dragMouseUp);
         DDW.Managers.GameManager.getInstance().cursor.removeEventListener(DDW.Events.MouseEvent.MOUSE_MOVE,this.dragMouseMove);
         this._hasDragListeners = false;
      }
      if(this._dragTimeoutId != 0)
      {
         _global.clearTimeout(this._dragTimeoutId);
         this._dragTimeoutId = 0;
      }
      this._startDragTimeout = false;
      this._isDragging = false;
      this._wasDragging = false;
   }
   function dragMouseUpInside(obj, e)
   {
      this.dragMouseUp(obj,e);
   }
   function dispatchMouseEvent(type, button, targetPath)
   {
      button = 1;
      targetPath = "_root";
      var _loc5_ = this._events[type];
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc9_;
      if(_loc5_ != null && _loc5_.length > 0)
      {
         _loc6_ = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            _loc8_ = new DDW.Events.MouseEvent(_loc7_.type,_loc7_.relatedObject,_loc7_.caller,_loc7_.callback,button,targetPath);
            _loc9_ = [this,_loc8_];
            _loc7_.callback.apply(_loc7_.caller,_loc9_);
            _loc6_ = _loc6_ + 1;
         }
      }
   }
   function dispatchEvent(type)
   {
      var _loc3_ = this._events[type];
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc3_ != null && _loc3_.length > 0)
      {
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = new DDW.Events.Event(_loc5_.type,_loc5_.relatedObject,_loc5_.caller,_loc5_.callback);
            _loc7_ = [this,_loc6_];
            _loc6_.callback.apply(_loc6_.caller,_loc7_);
            _loc4_ = _loc4_ + 1;
         }
      }
   }
   function dispatchKeyboardEvent(type)
   {
      var _loc3_ = this._events[type];
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      if(_loc3_ != null && _loc3_.length > 0)
      {
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = new DDW.Events.KeyboardEvent(_loc5_.type,_loc5_.relatedObject,_loc5_.caller,_loc5_.callback);
            _loc7_ = [this,_loc6_];
            _loc5_.callback.apply(_loc5_.caller,_loc7_);
            _loc4_ = _loc4_ + 1;
         }
      }
   }
   function addedToStage(event)
   {
      this.createGraphics();
      this.redraw();
      if(this.graphics != null)
      {
         this.graphics.stop();
      }
   }
   function removedFromStage(event)
   {
   }
   function addBaseEvents()
   {
      this._baseEventsCreated = true;
   }
   function removeBaseEvents()
   {
      this._baseEventsCreated = false;
   }
   function setCommNames(commMappings)
   {
   }
   function getValueMetrics(property)
   {
      var _loc3_;
      if(this[property] != null)
      {
         _loc3_ = new DDW.Utils.Metrics(null,null,null,null,null,null,property,this[property]);
      }
      return _loc3_;
   }
   function getMetrics()
   {
      var _loc2_ = new DDW.Utils.Metrics(this._x,this._y,this._width,this._height,this._alpha,this.scaleX);
      return _loc2_;
   }
   function isAnimating()
   {
      if(this._animationMetric != null)
      {
         return true;
      }
      return false;
   }
   function applyMetrics(m)
   {
      if(m.x != null)
      {
         this.x = m.x;
      }
      if(m.y != null)
      {
         this.y = m.y;
      }
      if(m.width != null)
      {
         this.width = m.width;
      }
      if(m.height != null)
      {
         this.height = m.height;
      }
      if(m.alpha != null)
      {
         this.alpha = m.alpha;
      }
      if(m.scale != null)
      {
         this.scaleX = m.scale;
         this.scaleY = m.scale;
      }
      if(m.value != null && m.propertyName != null)
      {
         this[m.propertyName] = m.value;
      }
   }
   function blinkOn()
   {
      this.blinkContinuous = true;
      this.blinkElement(1);
   }
   function blinkOff()
   {
      this.blinkContinuous = false;
      this.blinkCount = 0;
   }
   function blinkElement(count)
   {
      if(this.blinkIntervalID != -1)
      {
         _global.clearInterval(this.blinkIntervalID);
      }
      this.orgAlpha = this.alpha;
      this.orgTransform = this.graphics.transform.colorTransform;
      this.blinkTransform = new flash.geom.ColorTransform();
      this.blinkCount = count != null ? count : defaultBlinkCount;
      this.blinkStep = (this.maxBrightness - this.minBrightness) / (defaultBlinkDuration / 2 / 20);
      this.blinkTransform.redMultiplier = 1;
      this.blinkTransform.blueMultiplier = 1;
      this.blinkTransform.greenMultiplier = 1;
      this.blinkTransform.alphaMultiplier = 1;
      this.blinkTransform.redOffset = this.orgTransform.redOffset;
      this.blinkTransform.blueOffset = this.orgTransform.blueOffset;
      this.blinkTransform.greenOffset = this.orgTransform.greenOffset;
      this.blinkTransform.alphaOffset = this.orgTransform.alphaOffset;
      this.blinkIntervalID = _global.setInterval(this.blinkElementCallback,20,this);
   }
   function blinkElementCallback(scope)
   {
      var _loc3_ = scope.blinkTransform;
      var _loc4_ = scope.minBrightness;
      var _loc5_ = scope.maxBrightness;
      _loc3_.redOffset += scope.blinkStep;
      _loc3_.greenOffset += scope.blinkStep;
      _loc3_.blueOffset += scope.blinkStep;
      if(_loc3_.redOffset <= _loc4_)
      {
         scope.blinkStep = Math.abs(scope.blinkStep);
         _loc3_.redOffset = _loc4_;
         _loc3_.greenOffset = _loc4_;
         _loc3_.blueOffset = _loc4_;
      }
      else if(_loc3_.redOffset >= _loc5_)
      {
         scope.blinkStep = - Math.abs(scope.blinkStep);
         _loc3_.redOffset = _loc5_;
         _loc3_.greenOffset = _loc5_;
         _loc3_.blueOffset = _loc5_;
      }
      else if(_loc3_.redOffset >= scope.orgTransform.redOffset - Math.abs(scope.blinkStep / 2) && _loc3_.redOffset < scope.orgTransform.redOffset + Math.abs(scope.blinkStep / 2))
      {
         if(!scope.blinkContinuous)
         {
            scope.blinkCount = scope.blinkCount - 1;
         }
      }
      if(scope.blinkCount <= 0)
      {
         _global.clearInterval(scope.blinkIntervalID);
         scope.blinkIntervalID = -1;
         scope.blinkCount = 0;
         scope.graphics.transform.colorTransform = scope.orgTransform;
         scope.alpha = this.orgAlpha;
         scope.graphics.transform = null;
         scope.blinkTransform = null;
      }
      else
      {
         scope.graphics.transform.colorTransform = _loc3_;
      }
   }
   function doCommand(command, value, ind)
   {
      var _loc5_;
      if(command.length > 1)
      {
         if(typeof command[1] == "number")
         {
            this[command[0]][command[1]].doCommand(command.slice(2,command.length),value,ind);
         }
         else
         {
            this[command[0]].doCommand(command.slice(1,command.length),value,ind);
         }
      }
      else
      {
         if(value != null && value.toString() == "true")
         {
            value = true;
         }
         else if(value != null && value.toString() == "false")
         {
            value = false;
         }
         _loc5_ = typeof this[command[0]] != "function" ? "__set__" + command[0] : command[0];
         this[_loc5_](value,ind);
      }
   }
   function createGraphics(event)
   {
      this._isCreated = true;
   }
   function getFullPath()
   {
      var _loc2_ = "";
      var _loc3_ = this.parent;
      var _loc4_;
      var _loc5_;
      do
      {
         _loc4_ = _loc3_._class;
         _loc5_ = Object(_loc3_).index;
         if(_loc5_ != null)
         {
            _loc4_ += "[" + _loc5_ + "]";
         }
         _loc2_ = _loc4_ + "." + _loc2_;
         _loc3_ = _loc3_.parent;
      }
      while(_loc3_ != null);
      _loc2_ += this._libraryName;
      return _loc2_;
   }
   function traceObjectTree(data)
   {
      data.result = data.indent + "" + this.libraryName + ":" + this._class;
   }
   function toString()
   {
      return this._class + ":: id: " + this.id + " lib: " + this._libraryName;
   }
   function dispose()
   {
      if(!this._isDisposing)
      {
         this._isDisposing = true;
      }
   }
}
