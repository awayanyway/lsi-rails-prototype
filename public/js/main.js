/*
 * jQuery File Upload Plugin JS Example 8.9.0
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

/*jslint nomen: true, regexp: true */
/*global $, window, blueimp */

$(function () {
    'use strict';
    

    
    // Initialize the jQuery File Upload widget:
    $('#fileupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        url: uploadurl,
      //  filesContainer: $('.files'),
        replaceFileInput: false,
    });
    $('#fileupload').fileupload({
       //filesContainer: $('table.files'),
       // uploadTemplateId: null,
        downloadTemplateId: null,
        downloadTemplate: function (o) {
            var rows = $();
            $.each(o.files, function (index, file) {
                var row = $('<tr class="template-download fade">' +
                    '<td><span class="preview"></span></td>' +
                    '<td><p class="name"></p>' +
                    (file.error ? '<div class="error"></div>' : '') +
                    '</td>' +
                    '<td><span class="size"></span></td>' +
                    '<td><button class="btn btn-danger delete"><span>Delete</span></button>' +
                    '<input type="checkbox" name="delete" value="1" class="toggle"></td>'+
                    '</tr>'),
                    credential = {"withCredentials":true};
                row.find('.size').text(o.formatFileSize(file.size));
                if (file.error) {
                    row.find('.name').text(file.name);
                    row.find('.error').text(file.error);
                } else {
                    row.find('.name').append($('<a></a>').text(file.name));
                    if (file.thumbnailUrl) {
                        row.find('.preview').append(
                            $('<a></a>').append(
                                $('<img>')
                                          .prop('src', file.thumbnailUrl)
//                                          .height(40)
//                                          .width(60)            
                            )
                        );
                       row.find('img').clone(true).appendTo("#duplic");
//                       $("#duplic").find('img')
//                        .height(240)
//                        .width(360) ;
                        row.find('img')
                        .height(40)
                        .width(60);
                    }
                    row.find('a')
                        .attr('data-gallery', '')
                        .prop('href', file.url);
                    if (file.deleteUrl) { 
                     row.find('.delete')
                        .attr('data-type', file.deleteType)
                        .attr('data-url', file.deleteUrl);
                     row.find('button').append($('<i class="glyphicon glyphicon-trash"></i>'));
                    }
                    if (file.deleteWithCredentials) { 
                    	row.find('.delete').prop('data-xhr-fields', credential);
                     }
                }
                rows = rows.add(row);
            });
            return rows;
        }
    });
 //   }
    
    
    // Enable iframe cross-domain access via redirect option:
    
    $('#fileupload').fileupload(
        'option',
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );

        // Load existing files:
        $('#fileupload').addClass('fileupload-processing');
        $.ajax({
            // Uncomment the following to send cross-domain cookies:
            //xhrFields: {withCredentials: true},
            url: $('#fileupload').fileupload('option', 'url'),
            dataType: 'json',
            context: $('#fileupload')[0]
        }).always(function () {
            $(this).removeClass('fileupload-processing');
        }).done(function (result) {
            $(this).fileupload('option', 'done')
                .call(this, $.Event('done'), {result: result});
        });
    
  
    
    $('#fileupload').bind('fileuploadsubmit', function (e, data) {
      
      var myf = data.context.find('#relativePath')[0].innerHTML;

      $('#attachment_folder').val(myf);

      var inputs = $('#fileupload').serializeArray();

      data.formData = inputs;

    });
    
    $('#attachment_file').bind('fileuploadprogressall', function (e,data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      //$('.progress-bar').find('div').css('width',  progress + '%').find('span').html(progress + '%');
      console.info(progress);
    });
//    $('#fileupload').bind('fileuploaddone',
//    		function (e, data) { $('.files').clone(true).appendTo("#duplic");});

});
