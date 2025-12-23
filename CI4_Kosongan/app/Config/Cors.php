<?php

namespace Config;

use CodeIgniter\Config\BaseConfig;

/**
 * Cross-Origin Resource Sharing (CORS) Configuration
 *
 * @see https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
 */
class Cors extends BaseConfig
{
    /**
     * The default CORS configuration.
     *
     * @var array{
     *      allowedOrigins: list<string>,
     *      allowedOriginsPatterns: list<string>,
     *      supportsCredentials: bool,
     *      allowedHeaders: list<string>,
     *      exposedHeaders: list<string>,
     *      allowedMethods: list<string>,
     *      maxAge: int,
     *  }
     */
    public array $default = [
    'allowedOrigins'         => ['*'], // Izinkan semua (sangat penting!)
    'allowedOriginsPatterns' => [],
    'allowedHeaders'         => ['*'], // Izinkan semua header
    'allowedMethods'         => ['*'], // Izinkan GET, POST, DELETE, dll
    'exposedHeaders'         => [],
    'maxAge'                 => 7200,
    'supportsCredentials'    => false,
];
}
