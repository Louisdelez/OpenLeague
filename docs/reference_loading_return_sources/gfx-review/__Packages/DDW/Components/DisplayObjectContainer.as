class DDW.Components.DisplayObjectContainer extends DDW.Components.DisplayObject
{
   var _isDisposing;
   var _needsRedraw;
   var children;
   var commMappings;
   var graphics;
   var layoutData;
   var libraryName;
   var setCommNames;
   var showImage;
   var _class = "DisplayObjectContainer";
   var allowReorder = true;
   var layoutHash = [];
   function DisplayObjectContainer(libraryItem, mx)
   {
      super(libraryItem,mx);
      this.children = [];
   }
   function setDisplayMode(displayMode)
   {
      var _loc4_ = this.showImage;
      super.setDisplayMode(displayMode);
      var _loc5_;
      if(_loc4_)
      {
         _loc5_ = 0;
         while(_loc5_ < this.children.length)
         {
            this.children[_loc5_].setDisplayMode(displayMode);
            if(this.children[_loc5_].showImage)
            {
               this.showImage = true;
            }
            _loc5_ = _loc5_ + 1;
         }
      }
   }
   function addTo(parent)
   {
      super.addTo(parent);
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < this.children.length)
      {
         _loc5_ = this.children[_loc4_];
         _loc5_._layer = _loc4_;
         _loc5_.addTo(this);
         if(_loc5_.graphics.cls == -1)
         {
            _loc5_.graphics._alpha = 0;
            _loc5_.alpha = _loc5_.alpha;
         }
         else
         {
            _loc5_.graphics.cls = _loc5_;
         }
         _loc5_.redrawAll();
         _loc5_.attached = true;
         _loc5_.dispatchEvent(DDW.Events.Event.ADDED_TO_STAGE);
         _loc4_ = _loc4_ + 1;
      }
   }
   function removeFrom(parent)
   {
      var _loc4_ = 0;
      while(_loc4_ < this.children.length)
      {
         this.children[_loc4_].removeFrom(this);
         _loc4_ = _loc4_ + 1;
      }
      super.removeFrom(parent);
   }
   function redraw()
   {
      var _loc3_ = false;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(this._needsRedraw)
      {
         _loc4_ = 0;
         while(_loc4_ < this.children.length)
         {
            _loc5_ = this.children[_loc4_].redraw();
            _loc3_ = !_loc3_ ? _loc5_ : true;
            _loc4_ = _loc4_ + 1;
         }
         _loc6_ = super.redraw();
         _loc3_ = !_loc3_ ? _loc6_ : true;
      }
      this._needsRedraw = _loc3_;
      return _loc3_;
   }
   function redrawAll()
   {
      super.redrawAll();
      var _loc3_ = 0;
      while(_loc3_ < this.children.length)
      {
         this.children[_loc3_].redrawAll();
         _loc3_ = _loc3_ + 1;
      }
   }
   function resetDimmedStates()
   {
   }
   function draggingOver(dragObj)
   {
   }
   function addChild(child)
   {
      this.children.push(child);
      child.parent = this;
      if(this.graphics != null)
      {
         child._layer = this.children.length;
         child.addTo(this);
         child.graphics._alpha = 0;
         child.alpha = child.alpha;
         if(child.graphics.cls == -1)
         {
            child.needsRedraw();
         }
         else
         {
            child.graphics.cls = child;
         }
         child.attached = true;
         child.dispatchEvent(DDW.Events.Event.ADDED_TO_STAGE);
      }
   }
   function removeAllChild()
   {
      trace("removeAllChild:");
      trace("children.length :" + this.children.length);
      var _loc2_ = this.children.length - 1;
      while(_loc2_ > -1)
      {
         this.children.splice(_loc2_,1);
         this.children[_loc2_].removeFrom(this);
         trace("removeAllChild:: children:" + this.children);
         _loc2_ = _loc2_ - 1;
      }
   }
   function removeChild(child)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.children.length)
      {
         if(this.children[_loc3_]._layer == child._layer)
         {
            this.children.splice(_loc3_,1);
            this.reorderChildrenArray();
            child.removeFrom(this);
            break;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function contains(child)
   {
      var _loc3_ = false;
      var _loc4_;
      if(child.parent == this)
      {
         _loc4_ = 0;
         while(_loc4_ < this.children.length)
         {
            if(this.children[_loc4_]._layer == child._layer)
            {
               _loc3_ = true;
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      return _loc3_;
   }
   function getChildById(id)
   {
      var _loc4_ = 0;
      var _loc3_;
      while(_loc4_ < this.children.length)
      {
         trace("i:" + _loc4_);
         if(this.children[_loc4_].id == id)
         {
            trace("children[i].id == id:");
            _loc3_ = this.children[_loc4_];
            break;
         }
         _loc4_ = _loc4_ + 1;
      }
      return _loc3_;
   }
   function getChildIndex(child)
   {
      var _loc3_ = -1;
      var _loc4_;
      if(child.parent == this)
      {
         _loc4_ = 0;
         while(_loc4_ < this.children.length)
         {
            if(this.children[_loc4_]._layer == child._layer)
            {
               _loc3_ = _loc4_;
               break;
            }
            _loc4_ = _loc4_ + 1;
         }
      }
      return _loc3_;
   }
   function swapChildren(a, b)
   {
      var _loc4_ = a._layer;
      a._layer = b._layer;
      b._layer = _loc4_;
      if(a.graphics != null && b.graphics != null)
      {
         a.graphics.swapDepths(b.graphics);
         this.reorderChildrenArray();
      }
   }
   function swapChildrenAt(index1, index2)
   {
      var _loc4_;
      var _loc5_;
      var _loc6_;
      if(index1 >= 0 && (index2 >= 0 && (this.children.length > index1 && this.children.length > index2)))
      {
         _loc4_ = this.children[index1];
         _loc5_ = this.children[index2];
         _loc6_ = _loc4_.layer;
         _loc4_.layer = _loc5_.layer;
         _loc5_.layer = _loc6_;
         this.swapChildren(_loc4_,_loc5_);
      }
   }
   function setChildIndex(child, index)
   {
      this.allowReorder = false;
      var _loc4_ = this.getChildIndex(child);
      var _loc5_;
      var _loc6_;
      if(_loc4_ > -1)
      {
         if(index >= this.children.length)
         {
            index = this.children.length - 1;
         }
         else if(index < 0)
         {
            index = 0;
         }
         if(_loc4_ > index)
         {
            _loc5_ = _loc4_;
            while(_loc5_ > index)
            {
               this.swapChildrenAt(_loc4_,_loc5_ - 1);
               _loc5_ = _loc5_ - 1;
            }
         }
         else if(_loc4_ < index)
         {
            _loc6_ = _loc4_;
            while(_loc6_ < index)
            {
               this.swapChildrenAt(_loc4_,_loc6_ + 1);
               _loc6_ = _loc6_ + 1;
            }
         }
      }
      this.allowReorder = true;
      this.reorderChildrenArray();
   }
   function reorderChildrenArray()
   {
      var _loc2_;
      if(this.allowReorder)
      {
         this.children.sortOn("_layer",Array.NUMERIC);
         _loc2_ = 0;
         while(_loc2_ < this.children.length)
         {
            if(this.children[_loc2_]._layer != _loc2_ + 1)
            {
               if(this.children[_loc2_].graphics != null)
               {
                  this.children[_loc2_].graphics.swapDepths(_loc2_ + 1);
               }
               this.children[_loc2_]._layer = _loc2_ + 1;
            }
            _loc2_ = _loc2_ + 1;
         }
      }
   }
   function dispatchMouseEvent(type, button, targetPath)
   {
      super.dispatchMouseEvent(type,button,targetPath);
      var _loc6_ = 0;
      var _loc7_;
      while(_loc6_ < this.children.length)
      {
         _loc7_ = this.children[_loc6_];
         if(_loc7_._events[type] != null)
         {
            if(_loc7_.graphics.hitTest(_root._xmouse,_root._ymouse,true))
            {
               _loc7_.dispatchMouseEvent(type,button,targetPath);
            }
         }
         _loc6_ = _loc6_ + 1;
      }
   }
   function beginSnapshotCapture()
   {
      this.setDisplayMode(DDW.Enums.DisplayMode.staticOnly);
      this.redrawAll();
   }
   function endSnapshotCapture()
   {
      this.setDisplayMode(DDW.Enums.DisplayMode.dynamicOnly);
      this.redrawAll();
   }
   function setStaticElements()
   {
   }
   function setStaticState(value)
   {
      var _loc3_ = 0;
      while(_loc3_ < this.children.length)
      {
         if(this.children[_loc3_].length > 0)
         {
            this.children[_loc3_].setStaticState(value);
         }
         else
         {
            this.children[_loc3_].isStaticImage = value;
         }
         _loc3_ = _loc3_ + 1;
      }
   }
   function createGraphics()
   {
      var _loc3_;
      var _loc4_;
      var _loc5_;
      var _loc6_;
      var _loc7_;
      var _loc8_;
      var _loc2_;
      if(this.layoutHash != null)
      {
         _loc3_ = 0;
         while(_loc3_ < this.layoutHash.length)
         {
            _loc4_ = this.layoutHash[_loc3_];
            _loc5_ = _loc4_[0];
            _loc6_ = _loc4_.length <= 2 ? _loc5_ : _loc4_[2];
            _loc7_ = 0;
            while(_loc7_ < this.layoutData[_loc5_].length)
            {
               if(this.layoutData[_loc5_].length > 1)
               {
                  if(this[_loc6_] == null)
                  {
                     this[_loc6_] = [];
                  }
                  _loc8_ = this[_loc6_].length;
               }
               _loc2_ = this.addItem(_loc4_[1],_loc5_,this.layoutData[_loc5_][_loc7_],_loc8_);
               if(this.layoutData[_loc5_].length > 1)
               {
                  this[_loc6_].push(_loc2_);
               }
               else
               {
                  this[_loc6_] = _loc2_;
               }
               _loc7_ = _loc7_ + 1;
            }
            _loc3_ = _loc3_ + 1;
         }
         this.layoutHash = null;
      }
      this.setCommNames(this.commMappings);
      this.setStaticElements();
      this.graphics._focusrect = false;
      this.graphics.tabEnabled = false;
      this.graphics.tabChildren = false;
   }
   function addItem(cls, libName, mx, ind)
   {
      var _loc6_ = DDW.Managers.ComponentFactory.getInstance().createInstance(cls,libName,mx);
      _loc6_.index = ind;
      _loc6_.libraryName = libName;
      this.addChild(_loc6_);
      return _loc6_;
   }
   function addedToStage(event)
   {
      super.addedToStage();
   }
   function traceObjectTree(data)
   {
      var _loc3_ = data == null;
      data = !_loc3_ ? data : {result:"",children:[],indent:"",count:0};
      var _loc4_ = 0;
      var _loc5_;
      var _loc6_;
      if(this.children.length > 0)
      {
         _loc5_ = 0;
         while(_loc5_ < this.children.length)
         {
            _loc6_ = {result:"",children:[],indent:data.indent + "    ",count:0};
            this.children[_loc5_].traceObjectTree(_loc6_);
            data.children.push(_loc6_);
            _loc4_ += _loc6_.count;
            _loc5_ = _loc5_ + 1;
         }
      }
      data.count = this.children.length + _loc4_;
      data.result = data.indent + "" + this.libraryName + ":" + this._class + "#" + data.count;
      if(_loc3_)
      {
         this.traceObjectData(data);
      }
   }
   function traceObjectData(data)
   {
      var _loc3_;
      if(data.children != null)
      {
         _loc3_ = 0;
         while(_loc3_ < data.children.length)
         {
            this.traceObjectData(data.children[_loc3_]);
            _loc3_ = _loc3_ + 1;
         }
      }
   }
   function dispose()
   {
      if(!this._isDisposing)
      {
         super.dispose();
      }
   }
}
