services.factory('CategoryService', ['UserService', 'LocalCategoryService', '$http', 'LocalBookmarkService', 'resourceCache', function(UserService, LocalCategoryService, $http, LocalBookmarkService, resourceCache) {
    var service = {

        pageLoad: function(next) {

            var url = '/api/user/'+UserService.user.id+'/load';
            var promise = $http({
                method: 'GET',
                url: url,
                cache: resourceCache
            })
                .then(
                    function(response) {

                        LocalCategoryService.categories = [];
                        LocalBookmarkService.bookmarks  = [];
                        var categories = response.data;

                        for(var i in categories) {
                            var category = categories[i];
                            LocalCategoryService.addCategory(category);

                            for(var b in category.bookmarks) {
                                LocalBookmarkService.addBookmark(category.bookmarks[b]);
                            }
                        }

                        if(typeof(next) == 'function') {
                            next(categories.length);
                        }

                        //return response.data;
                    },
                    function(data) {
                        console.error("Can't retrieve bookmarks");
                        return {}
                    }
                );

            return promise;
        },








        getAll: function(next) {

            if(!UserService.isLogged) {

                return null;
            }else{

                if(LocalCategoryService.getCategories() === false) {

                    $http.get('/api/user/'+UserService.user.id+'/categories')
                    .success(
                        function(data, status, headers, config) {

                            if(typeof(next) == "function") {
                                next(data);
                            }
                    }).error(
                        function(data, status, headers, config) {
                            console.error("Can't retrieve categories");
                            return {}
                        }
                    );

                } else {
                    if(typeof(next) == "function") {
                        next(LocalCategoryService.getCategories());
                    }
                }
            }
        },

        get: function(id, cache) {

            if(!UserService.isLogged) {

                return null;
            } else {

                if(LocalCategoryService.get(id) === false || cache === false) {
                    var promise = $http.get('/api/user/'+UserService.user.id+'/category/'+id)
                    .then(
                        function(response) {

                            return response.data;
                        },
                        function(data) {
                            console.error("Can't retrieve category");
                            return {}
                        }
                    );

                    return promise.then(function(data) {

                        LocalCategoryService.setCategory(data);

                        return data;
                    });
                } else {

                    return LocalCategoryService.get(id);
                }
            }
        },

        post: function(category) {

            var promise = $http.post('/api/user/'+UserService.user.id+'/category', category)
            .then(
                    function(response) {

                    return response.data;
                },
                function(data) {
                    console.error("Can't add a category");
                    return {}
                }
            )

            return promise.then(function(data) {

                if(!LocalCategoryService.addCategory(data)) {
                    console.error("can't refresh data after post category");
                }

                return data;
            });
        },

        update: function(category) {

            var promise = $http.put('/api/user/'+UserService.user.id+'/category', category)
            .then(
                function(response) {

                    return response.data;
                },
                function(data) {
                    console.error("Can't update a category");
                    return {}
                }
            )

            return promise;
        },

        remove: function(category, next) {

            var promise = $http.delete('/api/user/'+UserService.user.id+'/category/'+category.id)
            .then(
                function(response) {
                    LocalCategoryService.remove(category);
                    next();
                },
                function(response) {
                    console.error("Error on removing the category");
                }
            );

            return promise;
        }
    }

    return service;
}]);
