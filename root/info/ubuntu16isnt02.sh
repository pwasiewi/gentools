
########################################################################################
#Ubuntu 16.04 with proprietary AMD driver for OpenCL
########################################################################################
sudo apt-get remove --purge fglrx*
#with webbrowser
#https://support.amd.com/en-us/kb-articles/Pages/AMDGPU-PRO-Install.aspx
#https://support.amd.com/en-us/kb-articles/Pages/Radeon-Software-for-Linux-Release-Notes.aspx
#get amdgpu-pro-17.50-511655.tar.xz
#[ ! -e amdgpu ] && mkdir amdgpu && cd amdgpu
#tar Jxvf amdgpu-pro-17.50-511655.tar.xz
cd amdpackages/amdgpu-pro-17.50-511655
./amdgpu-pro-install -y --opencl=rocm,legacy
cd .. 
#reboot
#get AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2 from  https://developer.amd.com/amd-license-agreement-appsdk
tar jxvf AMD-APP-SDKInstaller-v3.0.130.136-GA-linux64.tar.bz2
./AMD-APP-SDK-v3.0.130.136-GA-linux64.sh
ln -sfn /opt/AMDAPPSDK-3.0 /opt/AMDAPP
ln -sfn /opt/AMDAPPSDK-3.0 /opt/amdapp
wget https://www.khronos.org/registry/OpenCL/api/2.1/cl.hpp -O /opt/AMDAPP/include/CL/cl.hpp
echo libamdocl64.so > /etc/OpenCL/vendors/amdocl64.icd
#/opt, logout and login
