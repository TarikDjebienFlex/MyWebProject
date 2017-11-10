package mediators
{
	import flash.events.MouseEvent;
	
	import messages.GetKulerMessage;
	
	import models.DataModel;
	
	import mx.graphics.SolidColor;
	import mx.rpc.events.ResultEvent;
	
	import spark.primitives.Ellipse;
	
	import views.SearchView;

	public class SearchViewMediator
	{
		[Inject(id="model")]
		public var model:DataModel;
		
		[MessageDispatcher]
		public var dispatcher:Function;
		
		private var _view:SearchView;
		
		public function SearchViewMediator()
		{
			trace("Constructor controller");
		}
		
		[Init]
		public function init():void
		{
			trace("init, model :"+model);  
		}
		
		[Observe]
		public function initMediatedView( pview:SearchView ):void
		{
			this._view = pview;
			this._view.search_btn.addEventListener(MouseEvent.CLICK, onSearchHandler);
		}
		
		private function onSearchHandler(event:MouseEvent):void
		{
			var terms:String = this._view.search_ti.text;
			
			var message:GetKulerMessage = new GetKulerMessage();
			
			message.terms = terms;
			
			this.dispatcher( message );
		}
		
		[CommandResult(type="messages.GetKulerMessage", order="2")]
		public function handlerResult(event:ResultEvent):void
		{
			
			var colors:Vector.<uint> = model.colors.slice();
			var taille:int = colors.length;
			var circle:Ellipse;
			var color:uint;
			
			while(--taille > -1){
				circle = new Ellipse();
				color = colors[taille];
				circle.x = Math.random() * _view.stage.stageWidth;
				circle.y = Math.random() * _view.stage.stageHeight;
				circle.fill = new SolidColor( color , Math.random() );
				circle.width = circle.height = Math.random() * 150;
				_view.addElement( circle );
			}
			
		}
	}
}