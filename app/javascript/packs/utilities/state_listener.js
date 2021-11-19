$(document).on('ajax:error', function(e) {
    const error = JSON.parse(e.detail[0]).response;

    $('.authorization_errors').append(error);
})
