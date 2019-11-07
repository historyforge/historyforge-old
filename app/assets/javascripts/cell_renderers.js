function ActionCellRenderer () {}

// gets called once before the renderer is used
ActionCellRenderer.prototype.init = function(params) {
  // create the cell
  this.eGui = document.createElement('div');
  const link = document.location.toString().split('?')[0] + '/' + params.value;
  this.eGui.innerHTML = '<a href="' + link + '">View</a>';
};

// gets called once when grid ready to insert the element
ActionCellRenderer.prototype.getGui = function() {
  return this.eGui;
};

// gets called whenever the user gets the cell to refresh
ActionCellRenderer.prototype.refresh = function(params) {
  // set value into cell again
  // this.eValue.innerHTML = params.valueFormatted ? params.valueFormatted : params.value;
  // return true to tell the grid we refreshed successfully
  return true;
};

// gets called when the cell is removed from the grid
ActionCellRenderer.prototype.destroy = function() {};


function NameCellRenderer () {}

// gets called once before the renderer is used
NameCellRenderer.prototype.init = function(params) {
  // create the cell
  this.eGui = document.createElement('div');

  this.eGui.innerHTML = params.value.name;
  if (!params.value.reviewed) {
    this.eGui.innerHTML += '<span class="badge badge-danger">NEW</span>';
  }
};

// gets called once when grid ready to insert the element
NameCellRenderer.prototype.getGui = function() {
  return this.eGui;
};

// gets called whenever the user gets the cell to refresh
NameCellRenderer.prototype.refresh = function(params) {
  // set value into cell again
  // this.eValue.innerHTML = params.valueFormatted ? params.valueFormatted : params.value;
  // return true to tell the grid we refreshed successfully
  return true;
};

// gets called when the cell is removed from the grid
NameCellRenderer.prototype.destroy = function() {};
