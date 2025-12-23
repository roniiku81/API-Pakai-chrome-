<?php

use CodeIgniter\Router\RouteCollection;

/**
 * @var RouteCollection $routes
 */
$routes->get('/', 'Home::index');
$routes->resource('siswa');
$routes->get('siswa', 'Siswa::index');
$routes->post('siswa', 'Siswa::create');
$routes->delete('siswa/(:num)', 'Siswa::delete/$1');
$routes->put('siswa/(:num)', 'Siswa::update/$1');
