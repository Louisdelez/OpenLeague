package flexlib.controls
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.DisplacementMapFilter;
   import flash.filters.DisplacementMapFilterMode;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.GradientEntry;
   import mx.graphics.RadialGradient;
   
   public class Fire extends UIComponent
   {
      
      private var _blendMode:String = BlendMode.SCREEN;
      
      private var a:Array = new Array();
      
      private var _delay:Number = 0;
      
      private var noiseBitmap:BitmapData;
      
      private var output:Bitmap;
      
      [Bindable]
      private var _92211241hFactor:Number = 5;
      
      [Bindable]
      private var _1796362938displacementScaleY:Number = 50;
      
      private var _color:uint = 16737792;
      
      [Bindable]
      private var _1482236972_angle:Number = 90;
      
      private var _colors:Array = [_color];
      
      public var xSpeed:Number = 0;
      
      private var fire:BitmapData;
      
      private var timer:Timer;
      
      public var ySpeed:Number = 1;
      
      private var _octaves:int = 2;
      
      [Bindable]
      private var _335442086wFactor:Number = 6;
      
      [Bindable]
      private var _1796362939displacementScaleX:Number = 50;
      
      protected var input:Sprite;
      
      public function Fire()
      {
         super();
      }
      
      public function get fireBlendMode() : String
      {
         return _blendMode;
      }
      
      protected function createInput(g:Graphics, w:Number, h:Number) : void
      {
         var fill:RadialGradient = null;
         var entries:Array = null;
         var i:int = 0;
         g.clear();
         fill = new RadialGradient();
         entries = new Array();
         for(i = 0; i < _colors.length; i++)
         {
            entries.push(new GradientEntry(_colors[i]));
         }
         entries.push(new GradientEntry(0,0.6));
         fill.entries = entries;
         fill.angle = _angle;
         fill.focalPointRatio = 0.6;
         fill.begin(g,new Rectangle(0,0,w,h));
         g.drawRect(0,0,w,h);
         fill.end(g);
      }
      
      public function get detail() : int
      {
         return _octaves;
      }
      
      [Bindable(event="propertyChange")]
      public function get wFactor() : Number
      {
         return this._335442086wFactor;
      }
      
      public function set detail(value:int) : void
      {
         var i:int = 0;
         if(a.length < value)
         {
            for(i = 0; i < value - a.length; i++)
            {
               a.push(new Point());
            }
         }
         else if(a.length > value)
         {
            a.splice(value);
         }
         _octaves = value;
      }
      
      public function startBurning() : void
      {
         if(_delay > 0)
         {
            timer.start();
         }
         else
         {
            this.systemManager.addEventListener(Event.ENTER_FRAME,makeNoise,false,0,true);
         }
      }
      
      public function get angle() : Number
      {
         return _angle;
      }
      
      [Bindable]
      private function set _94842723color(value:uint) : void
      {
         this.colors = [value];
      }
      
      [Bindable(event="propertyChange")]
      public function get displacementScaleY() : Number
      {
         return this._1796362938displacementScaleY;
      }
      
      [Bindable(event="propertyChange")]
      public function get displacementScaleX() : Number
      {
         return this._1796362939displacementScaleX;
      }
      
      public function set wFactor(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this._335442086wFactor;
         if(oldValue !== value)
         {
            this._335442086wFactor = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wFactor",oldValue,value));
         }
      }
      
      public function stopBurning() : void
      {
         if(Boolean(timer) && timer.running)
         {
            timer.stop();
         }
         else if(Boolean(this.systemManager))
         {
            this.systemManager.removeEventListener(Event.ENTER_FRAME,makeNoise);
         }
      }
      
      public function get colors() : Array
      {
         return _colors;
      }
      
      public function get delay() : Number
      {
         return _delay;
      }
      
      public function set angle(value:Number) : void
      {
         _angle = value;
         createInput(input.graphics,width,height);
      }
      
      protected function makeNoise(event:Event) : void
      {
         var i:int = 0;
         var d:DisplacementMapFilter = null;
         var pt:Point = null;
         for(i = 0; i < _octaves; i++)
         {
            pt = a[i] as Point;
            pt.x += xSpeed;
            pt.y += ySpeed;
         }
         noiseBitmap.perlinNoise(input.width / wFactor,input.height / hFactor,_octaves,Math.random(),true,false,7,true,a);
         d = new DisplacementMapFilter(noiseBitmap,new Point(0,0),1,2,displacementScaleX,displacementScaleY,DisplacementMapFilterMode.IGNORE);
         fire.draw(input);
         fire.applyFilter(fire,fire.rect,new Point(0,0),d);
         output.bitmapData = fire;
      }
      
      [Bindable]
      private function set _1354842768colors(value:Array) : void
      {
         _colors = value;
         if(Boolean(input))
         {
            createInput(input.graphics,width,height);
         }
      }
      
      public function set displacementScaleY(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this._1796362938displacementScaleY;
         if(oldValue !== value)
         {
            this._1796362938displacementScaleY = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displacementScaleY",oldValue,value));
         }
      }
      
      public function set displacementScaleX(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this._1796362939displacementScaleX;
         if(oldValue !== value)
         {
            this._1796362939displacementScaleX = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displacementScaleX",oldValue,value));
         }
      }
      
      [Bindable]
      private function set _1950972930fireBlendMode(value:String) : void
      {
         _blendMode = value;
         if(Boolean(output))
         {
            output.blendMode = value;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set color(value:uint) : void
      {
         var oldValue:Object = null;
         oldValue = this.color;
         if(oldValue !== value)
         {
            this._94842723color = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"color",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set colors(value:Array) : void
      {
         var oldValue:Object = null;
         oldValue = this.colors;
         if(oldValue !== value)
         {
            this._1354842768colors = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colors",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set delay(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this.delay;
         if(oldValue !== value)
         {
            this._95467907delay = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"delay",oldValue,value));
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         noiseBitmap = new BitmapData(1,1,true,0);
         fire = new BitmapData(1,1,true,0);
         input = new Sprite();
         output = new Bitmap();
         output.blendMode = _blendMode;
         output.smoothing = true;
         addChild(output);
      }
      
      public function get color() : uint
      {
         return _colors[0];
      }
      
      override public function initialize() : void
      {
         var i:int = 0;
         super.initialize();
         if(a.length < _octaves)
         {
            for(i = 0; i < _octaves - a.length + 1; i++)
            {
               a.push(new Point());
            }
         }
         if(_delay > 0)
         {
            timer = new Timer(1);
            timer.addEventListener(TimerEvent.TIMER,makeNoise,false,0,true);
         }
         else
         {
            this.systemManager.addEventListener(Event.ENTER_FRAME,makeNoise,false,0,true);
         }
      }
      
      private function set _angle(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this._1482236972_angle;
         if(oldValue !== value)
         {
            this._1482236972_angle = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_angle",oldValue,value));
         }
      }
      
      [Bindable]
      private function set _95467907delay(value:Number) : void
      {
         _delay = value;
         if(_delay > 0)
         {
            if(!timer)
            {
               timer = new Timer(_delay);
               timer.addEventListener(TimerEvent.TIMER,makeNoise,false,0,true);
            }
            else
            {
               timer.delay = _delay;
            }
            stopBurning();
            timer.start();
         }
         else
         {
            if(Boolean(timer))
            {
               timer.stop();
            }
            if(initialized)
            {
               this.systemManager.addEventListener(Event.ENTER_FRAME,makeNoise,false,0,true);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get _angle() : Number
      {
         return this._1482236972_angle;
      }
      
      public function set hFactor(value:Number) : void
      {
         var oldValue:Object = null;
         oldValue = this._92211241hFactor;
         if(oldValue !== value)
         {
            this._92211241hFactor = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hFactor",oldValue,value));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hFactor() : Number
      {
         return this._92211241hFactor;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(unscaledWidth > 0 && unscaledHeight > 0)
         {
            createInput(input.graphics,unscaledWidth,unscaledHeight);
            if(Boolean(noiseBitmap))
            {
               noiseBitmap.dispose();
            }
            if(Boolean(fire))
            {
               fire.dispose();
            }
            noiseBitmap = new BitmapData(unscaledWidth,unscaledHeight,true,0);
            fire = new BitmapData(unscaledWidth,unscaledHeight,true,0);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set fireBlendMode(value:String) : void
      {
         var oldValue:Object = null;
         oldValue = this.fireBlendMode;
         if(oldValue !== value)
         {
            this._1950972930fireBlendMode = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fireBlendMode",oldValue,value));
         }
      }
   }
}

