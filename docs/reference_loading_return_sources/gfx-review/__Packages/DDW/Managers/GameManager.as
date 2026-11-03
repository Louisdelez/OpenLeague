class DDW.Managers.GameManager extends DDW.Components.DisplayObjectContainer
{
   var _cursor;
   var _gameLoopInterval;
   var _isDisposing;
   var _isGfx;
   var _needsRedraw;
   var addChild;
   var graphics;
   var libraryName;
   var mouseManager;
   var redraw;
   static var _instance;
   static var _frameRate = 50;
   var loopCount = 0;
   function GameManager(s)
   {
      super();
      if(s != "use getInstance")
      {
         throw new Error("GameManager is a singleton object. Use GameManager.getInstance");
      }
      org.flashdevelop.utils.FlashViewer.limit = 5000;
      _global.gfxExtensions = true;
      this._isGfx = _global.gfxVersion == undefined ? false : true;
      this.libraryName = "_root";
      this.graphics = _root;
      this.mouseManager = new DDW.Managers.MouseManager();
      _global.BatchCommands = BatchCommands;
      var _loc4_ = !this._isGfx ? Math.floor(1000 / _frameRate) : 50;
      this._gameLoopInterval = _global.setInterval(this,"gameLoop",_loc4_);
      trace("_frameRate:" + _frameRate);
   }
   static function getInstance()
   {
      if(_instance == null)
      {
         _instance = new DDW.Managers.GameManager("use getInstance");
      }
      return _instance;
   }
   function get isGfx()
   {
      return this._isGfx;
   }
   function get cursor()
   {
      if(this._cursor == null)
      {
         this._cursor = new DDW.Components.Cursor();
         this.addChild(this.cursor);
         this.redraw();
      }
      return this._cursor;
   }
   function gameLoop()
   {
      if(this._needsRedraw)
      {
         this._needsRedraw = this.redraw();
      }
   }
   static function BatchCommands(s)
   {
      var _loc3_ = s.split(";;");
      var _loc4_ = 0;
      var _loc5_;
      while(_loc4_ < _loc3_.length)
      {
         _loc5_ = _loc3_[_loc4_].split("||");
         _global[_loc5_[0]](_loc5_[1]);
         _loc4_ = _loc4_ + 1;
      }
   }
   function createGraphics()
   {
      super.createGraphics();
   }
   function dispose()
   {
      if(!this._isDisposing)
      {
         super.dispose();
      }
   }
}
