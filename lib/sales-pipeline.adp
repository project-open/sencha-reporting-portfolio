<div id=@diagram_id@></div>
<script type='text/javascript'>

// Ext.Loader.setConfig({enabled: true});
Ext.Loader.setPath('Ext.ux', '/sencha-v411/examples/ux');
Ext.Loader.setPath('PO.model', '/sencha-core/model');
Ext.Loader.setPath('PO.store', '/sencha-core/store');
Ext.Loader.setPath('PO.class', '/sencha-core/class');
Ext.Loader.setPath('PO.view.gantt', '/sencha-core/view/gantt');
Ext.Loader.setPath('PO.controller', '/sencha-core/controller');

Ext.require([
    'Ext.data.*',
    'Ext.grid.*',
    'Ext.tree.*',
    'PO.class.CategoryStore',
    'PO.store.project.ProjectMainStore'
]);

function launchDiagram(){
    var statusStore = Ext.StoreManager.get('projectStatusStore');
    var projectMainStore = Ext.StoreManager.get('projectMainStore');

    var store1 = Ext.create('Ext.data.JsonStore', {
        fields: ['x_axis', 'y_axis', 'color', 'diameter', 'caption'],
        data: [
	    {x_axis: 909000.00, y_axis: 60.00, color: 'blue', diameter: 95.3414914924242200, caption: 'Play House (2014-05-09)'},
	    {x_axis: 146400.00, y_axis: 80.00, color: 'blue', diameter: 38.2622529394179800, caption: 'Special Machine Half (2014-05-13)'},
	    {x_axis: 57000.00, y_axis: 50.00, color: 'blue', diameter: 23.8746727726266400, caption: 'SCRUM Generic 1 (2014-05-14)'}
	]
    });

    function createHandler(fieldName) {
	return function(sprite, record, attr, index, store) {
	    return Ext.apply(attr, {
		radius: record.get('diameter'),
		fill: record.get('color')
	    });
	};
    };
    
    var chart = new Ext.chart.Chart({
        width: 300,
        height: 300,
        animate: true,
        store: store1,
        renderTo: '@diagram_id@',
	axes: [{
	    type: 'Numeric', position: 'left', fields: ['y_axis'], grid: true
	}, {
	    type: 'Numeric', position: 'bottom', fields: ['x_axis']
	}],
	series: [{
	    type: 'scatter',
	    axis: 'left',
	    xField: 'x_axis',
	    yField: 'y_axis',
	    highlight: true,
	    markerConfig: { type: 'circle' },
	    renderer: createHandler('xxx'),
	    label: {
                display: 'under',
                field: 'caption',
                'text-anchor': 'left',
		color: '#000'
            }
	}]
    });

};

Ext.onReady(function() {
    Ext.QuickTips.init();

    var statusStore = Ext.create('PO.store.project.ProjectStatusStore');
    var projectMainStore = Ext.create('PO.store.project.ProjectMainStore');
    var coordinator = Ext.create('PO.controller.StoreLoadCoordinator', {
        stores: [
            'projectStatusStore', 
            'projectMainStore'
        ],
        listeners: {
            load: function() {
                // Check if the application was launched before
                if ("boolean" == typeof this.loadedP) { return; }
                // Launch the actual application.
                launchDiagram();
                // Mark the application as launched
                this.loadedP = true;
            }
        }
    });
});
</script>
</div>
