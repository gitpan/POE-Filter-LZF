use inc::Module::Install;
name 'POE-Filter-LZF';
author 'Chris Williams <chris@bingosnet.co.uk';
license 'perl';
version_from 'lib/POE/Filter/LZF.pm';
requires 'Carp' => 0;
requires 'POE'    => 0.38;
requires 'Compress::LZF' => 1.51;
WriteAll();
