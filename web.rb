#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'json'
require 'pg'

    conn = PG::connect(:host => 'ec2-54-204-44-31.compute-1.amazonaws.com', :port => 5432, :dbname => 'daka8s9502p8uo', :user => 'psczeygltqeesf', :passwordd => 'pEETVlkA65Lq7qboYkac1WbPZZ')

def getSongs(groupid)
    
    res = conn.exec("select songid,song,artist,album,albumurl from #{groupid} order by placeid").values()
    res.each do |song|
        song[0]="{songid: #{song[0]}"
        song[1]="properties: [ {song: #{song[1]}}"
        song[2]="{artist: #{song[2]}}"
        song[3]="{album: #{song[3]}}"
        song[4]="{aurl: #{song[4]}}]}"
        song = song.join(',')
    end
    json_out_str = "[#{res.join(',')}]".to_json.to_s
    File.open('songs.json','w') {|f| f.write(json_out_str)}
    send_file('songs.json')
end

    post 'create/:groupid' do
        begin 
            conn.exec("create table #{params[:groupid]} (placeid int not null, songid varchar(255), song varchar(255), artist varchar(255), album varchar(255), albumurl varchar(255) primary key (placeid))")
        rescue PG::error => err
            if(err.result.error_field( PG::Result::PG_DIAG_SQLSTATE ).eql? "42P07")
                getSongs(params[:groupid])
            end
        end
    end

    get 'join/:groupid' do
        begin
            getSongs(params[:groupid])
        rescue PG::error => err
            if(err.result.error_field( PG::Result::PG_DIAG_SQLSTATE ).eql? "42P01")
                File.open('songs.json', 'w') {|f| f.write("{error: 'No table with name #{params[:groupid]} detected!'}")}
                send_file('songs.json')
            end
        end
    end
    patch 'add/:groupid/:songid/:song/:artist/:album/:aurl' do
        place = conn.exec("select count(*) from #{params[:groupid]}")
        conn.exec("insert into #{params[:groupid]} values (#{place}, #{params[:songid]}, #{params[:song]}, #{params[:artist]}, #{params[:album]}, #{params[:aurl]})")
    end
    patch 'remove/:groupid/:placeid' do
        conn.exec("delete from #{params[:groupid]} where placeid=#{params[:placeid]}")
    end
    delete 'leave/:groupid' do
        conn.exec("drop table #{params[:groupid]}")
    end
